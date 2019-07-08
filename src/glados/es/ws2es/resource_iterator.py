import requests
from glados.es.ws2es.util import SharedThreadPool
import os
import sys
import glados.es.ws2es.signal_handler as signal_handler
import glados.es.ws2es.progress_bar_handler as progress_bar_handler
import glados.es.ws2es.resources_description as resources_description
import time
import random
from threading import Lock, Thread
import traceback
import json
from urllib.parse import urlparse


# noinspection PyBroadException
class ResourceIterator(Thread):

    LIMIT = 1000
    MAX_RETRIES = 30

    def __init__(self, resource: resources_description.ResourceDescription, thread_pool: SharedThreadPool,
                 progress_records_base_path=os.getcwd(),
                 on_start=None, on_doc=None, on_done=None, iterate_all=False, redo_failed_chunks=False):
        super().__init__()
        self.resource = resource
        base_path = os.path.join(progress_records_base_path, 'ws-iterator-progress')
        self.progress_records_base_path = os.path.join(base_path, self.resource.res_name)
        os.makedirs(self.progress_records_base_path, exist_ok=True)
        self.fail_file = os.path.join(base_path, self.resource.res_name+'-failed-chunks')
        self.count_file = os.path.join(base_path, self.resource.res_name+'-count')
        ws_endpoint = resources_description.WS_URL_TO_USE
        parsed_url = urlparse(ws_endpoint)

        self.domain = parsed_url.scheme + '://' + parsed_url.netloc
        self.base_url_path = parsed_url.path + '/{0}.json?offset={1}&limit='+str(ResourceIterator.LIMIT)

        self.stop = False
        signal_handler.add_termination_handler(self.stop_iterator)
        self.scheduled_tasks = []
        self.total_count = 0
        self.iterated_count = 0
        self.count_future = None
        self.progress_bar = None
        self.thread_pool = thread_pool
        self.scheduled_tasks_count = 0
        self.sync_lock = Lock()
        self.iterate_all = iterate_all
        self.redo_failed_chunks = redo_failed_chunks
        # Callable parameters check
        self.on_start = None
        if on_start:
            if callable(on_start):
                self.on_start = on_start
            else:
                raise Exception('on_start parameter is not callable')
        self.on_doc = None
        if on_doc:
            if callable(on_doc):
                self.on_doc = on_doc
            else:
                raise Exception('on_doc parameter is not callable')
        self.on_done = None
        if on_done:
            if callable(on_done):
                self.on_done = on_done
            else:
                raise Exception('on_done parameter is not callable')

    def _build_url(self, offset=0):
        return self.domain + self.base_url_path.format(self.resource.res_name, offset)

    def _get_resource_count(self):
        try:
            with open(self.count_file, 'r') as pf:
                lines = pf.read().splitlines()
                if lines[0] == 'OK':
                    return int(lines[1])
        except:
            pass
        res_url = self._build_url()
        req = requests.get(res_url)
        response = req.json()
        res_count = response['page_meta']['total_count']
        with open(self.count_file, 'w') as pf:
            pf.write('OK\n')
            pf.write('{0}\n'.format(res_count))
        return res_count

    @staticmethod
    def _get_resource_response_list(json_response: dict):
        resp_keys = set(json_response.keys())
        resp_keys.remove('page_meta')
        resource_key = list(resp_keys)[0]
        return json_response[resource_key]

    @staticmethod
    def _check_progress(progress_path):
        try:
            with open(progress_path, 'r') as pf:
                lines = pf.read().splitlines()
                if lines[0] == 'OK':
                    return int(lines[1])
                return -1
        except:
            return -1

    def stop_iterator(self, signal, frame):
        self.stop = True

    def _iterate_chunk_slice(self, resource_list):
        for doc_i in resource_list:
            try:
                if doc_i and self.on_doc:
                    if self.resource.res_name == 'chembl_id_lookup':
                        try:
                            doc_i['chembl_id_number'] = int(doc_i['chembl_id'].replace("CHEMBL", ''))
                        except:
                            doc_i['chembl_id_number'] = -1
                            print("ERROR: {0} is not a valid CHEMBL ID".format(doc_i['chembl_id']), file=sys.stderr)
                            sys.stderr.flush()
                    self.on_doc(self.resource.res_name, self.resource.resource_ids, doc_i)
            except:
                traceback.print_exc()
                print('Resource="{0}", Resource IDs="{1}, Doc={2}\n'
                      .format(self.resource.res_name, self.resource.resource_ids, doc_i), file=sys.stderr)
                print('Exception caught: \n{0}\n'.format(traceback.format_exc()), file=sys.stderr)
                sys.stderr.flush()

    def _iterate_resource_chunk(self, start, end):
        return_value = 0
        next_url = None
        success = False
        current_try = 0
        progress_path = os.path.join(self.progress_records_base_path, str(start))
        while not success and current_try < ResourceIterator.MAX_RETRIES and not self.stop:
            current_try += 1
            try:
                progress_count = ResourceIterator._check_progress(progress_path)
                if progress_count != -1 and not self.redo_failed_chunks:
                    return_value = progress_count
                else:
                    next_url = self._build_url(start)
                    current = start
                    total_count = 0
                    while current < end and next_url and not self.stop:
                        response = None
                        cache_file_path = '{0}-{1}.json'.format(progress_path, current)
                        if os.path.exists(cache_file_path):
                            try:
                                with open(cache_file_path, 'r') as f:
                                    response = json.load(f)
                            except:
                                traceback.print_exc()
                                response = None
                        if response is None:
                            req = requests.get(next_url)
                            if req.status_code != 200:
                                raise Exception("STATUS CODE: {0}".format(req.status_code))
                            response = req.json()
                            try:
                                with open(cache_file_path, 'w') as f:
                                    response = json.dump(response, f)
                            except:
                                traceback.print_exc()
                        resource_list = ResourceIterator._get_resource_response_list(response)
                        total_count += len(resource_list)
                        self._iterate_chunk_slice(resource_list)

                        next_url = response['page_meta']['next']
                        if next_url:
                            next_url = self.domain + next_url
                        current += ResourceIterator.LIMIT
                    if not self.stop:
                        with open(progress_path, 'w') as pf:
                            pf.write('OK\n')
                            pf.write('{0}\n'.format(total_count))
                        return_value = total_count
                success = True
            except:
                if current_try < ResourceIterator.MAX_RETRIES:
                    print(
                        'TRY {0} FAILED: {1} offset: {2}\nURL: {3}'
                            .format(current_try, self.resource.res_name, start, next_url),
                        file=sys.stderr
                    )
                    sys.stderr.flush()
                else:
                    traceback.print_exc()
                    print('CHUNK FAILED: {0} offset: {1}\nURL: {2}'.format(self.resource.res_name, start, next_url),
                          file=sys.stderr)
                    sys.stderr.flush()
                    with open(self.fail_file, 'a') as pf:
                        pf.write('FAILED: {0} - {1} URL: {2}\n'.format(self.resource.res_name, start, next_url))
        self.sync_lock.acquire()
        self.scheduled_tasks_count -= 1
        self.sync_lock.release()
        return return_value

    def _submit_iterate_resource_chunk_to_queue(self, start, end):
        while self.scheduled_tasks_count >= 20:
            time.sleep(random.choice([1, 0.5, 0.2, 0.1]))
            self.check_progress_bar()
            if self.stop:
                return None
        if not self.stop:
            self.sync_lock.acquire()
            self.scheduled_tasks_count += 1
            self.sync_lock.release()
            return self.thread_pool.submit(self._iterate_resource_chunk, start, end)
        return None

    def iterate_resource(self):
        self.count_future = self.thread_pool.submit(self._get_resource_count)
        self.total_count = self.count_future.result()
        self.iterated_count = 0
        chunk_size = ResourceIterator.LIMIT*3
        self.progress_bar = progress_bar_handler.get_new_progressbar(self.resource.res_name, self.total_count)
        if self.on_start:
            try:
                self.on_start(self.resource.res_name, self.total_count)
            except:
                print('Exception on resource "{0}" start.\n'.format(self.resource.res_name), file=sys.stderr)
                print('Exception caught: \n{0}\n'.format(traceback.format_exc()), file=sys.stderr)
                print('ERROR: on_resource_start for {0} failed exiting now!'.format(self.resource.res_name),
                      file=sys.stderr)
                sys.stderr.flush()
                return
        stop_at = self.total_count if self.iterate_all else (ResourceIterator.LIMIT * 10)
        for offset_i in range(0, stop_at, chunk_size):
            if self.stop:
                return
            task = self._submit_iterate_resource_chunk_to_queue(offset_i, offset_i + chunk_size)
            if task:
                self.scheduled_tasks.append(task)
        self.check_progress_bar(wait_to_finish=True)

        if not self.stop and self.on_done:
            self.on_done(self.resource.res_name)

    def check_progress_bar(self, wait_to_finish=False):
        last_count = self.iterated_count
        not_ready = []
        for task_i in self.scheduled_tasks:
            if wait_to_finish or task_i.done():
                self.iterated_count += task_i.result()
            else:
                not_ready.append(task_i)
        if last_count != self.iterated_count:
            self.progress_bar.update(self.iterated_count)

        if not wait_to_finish:
            self.scheduled_tasks = not_ready

        if self.iterated_count == self.total_count:
            self.progress_bar.finish()

    def run(self):
        try:
            self.iterate_resource()
        except:
            traceback.print_exc()


def iterate_all_ws_resources():
    shared_thread_pool = SharedThreadPool(max_workers=10)
    shared_thread_pool.start()
    iterators = []
    for resource_i in resources_description.ALL_WS_RESOURCES:
        res_it_i = ResourceIterator(resource_i, shared_thread_pool, iterate_all=True)
        res_it_i.start()
        iterators.append(res_it_i)
    for res_it_i in iterators:
        res_it_i.join()
    shared_thread_pool.join()


if __name__ == '__main__':
    iterate_all_ws_resources()
