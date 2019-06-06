import copy
from concurrent.futures import ThreadPoolExecutor
from threading import Thread
import glados.ws2es.signal_handler as signal_handler
import time
from wrapt.decorators import synchronized
import sys


def get_js_path_from_dict(doc: dict, js_path, default=None):
    if doc is None:
        return None
    js_path_parts = js_path.split('.')
    cur_level = doc
    for js_path_part_i in js_path_parts:
        if isinstance(cur_level, list):
            next_level = []
            for cur_level_j in cur_level:
                if isinstance(cur_level_j, dict):
                    if js_path_part_i in cur_level_j:
                        next_level.append(cur_level_j[js_path_part_i])
            cur_level = next_level
            if len(cur_level) == 0:
                break
        else:
            cur_level = cur_level.get(js_path_part_i, None)
            if cur_level is None:
                break
    if default is not None and cur_level is None:
        return default
    return cur_level


def put_js_path_in_dict(doc: dict, js_path, value, es_properties_style=False):
    if doc is None:
        doc = {}
    if es_properties_style:
        js_path = js_path.replace('.', '.properties.')

    # remove trailing and leading '.'
    if js_path[0] == '.':
        js_path = js_path[1:]
    if js_path[-1] == '.':
        js_path = js_path[:-1]

    js_path_parts = js_path.split('.')
    cur_level = doc
    for i, js_path_part_i in enumerate(js_path_parts):
        if i == len(js_path_parts)-1:   # if last
            cur_level[js_path_part_i] = value
        else:
            if js_path_part_i not in cur_level or not isinstance(cur_level[js_path_part_i], dict):
                cur_level[js_path_part_i] = {}
            cur_level = cur_level[js_path_part_i]
    return doc


class SummableDict(dict):

    @staticmethod
    def is_subclass_of_dict(obj):
        return issubclass(obj.__class__, dict)

    @staticmethod
    def mix_dicts(dict_a, dict_b):
        for key_i in dict_b.keys():
            if key_i in dict_a and SummableDict.is_subclass_of_dict(dict_a[key_i]) \
                    and SummableDict.is_subclass_of_dict(dict_b[key_i]):
                SummableDict.mix_dicts(dict_a[key_i], dict_b[key_i])
            else:
                dict_a[key_i] = dict_b[key_i]

    def __add__(self, other):
        self_copy = copy.deepcopy(self)
        if SummableDict.is_subclass_of_dict(other):
            SummableDict.mix_dicts(self_copy, other)
        elif other and issubclass(other.__class__, (tuple, list)) and len(other) == 2:
            self_copy[other[0]] = other[1]
        else:
            raise Exception("ERROR: Unsupported type! Must add a dictionary or a tuple or list of size 2.")
        return self_copy

    def __sub__(self, keys_list):
        for key_i in keys_list:
            self.pop(key_i, None)
        return self


def count_fields_in_doc(doc):
    cur_count = 0
    if isinstance(doc, list):
        for sub_doc in doc:
            cur_count += count_fields_in_doc(sub_doc)
    elif isinstance(doc, dict):
        for sub_doc in doc.values():
            cur_count += count_fields_in_doc(sub_doc)
    else:
        cur_count += 1
    return cur_count


# noinspection PyBroadException
class SharedThreadPool(Thread):

    def __init__(self, max_workers=10, label='SharedThreadPool'):
        super().__init__()
        self.max_workers = max_workers
        self.max_queue_size = max_workers * 1000
        self.current_tasks_queue = []
        self.thread_pool = ThreadPoolExecutor(max_workers=max_workers)
        self.stop_thread_pool = False
        self.label = label
        signal_handler.add_termination_handler(self.stop_pool)

    def stop_pool(self, signal, frame):
        self.stop_thread_pool = True

    @synchronized
    def check_finished_tasks(self):
        next_queue = []
        for task_i in self.current_tasks_queue:
            if not task_i.done():
                next_queue.append(task_i)
        del self.current_tasks_queue
        self.current_tasks_queue = next_queue

    @synchronized
    def get_tasks_queue_length(self):
        return len(self.current_tasks_queue)

    @synchronized
    def add_task_to_queue(self, task):
        self.current_tasks_queue.append(task)

    def submit(self, fn, *args, **kwargs):
        return_future = None
        while self.get_tasks_queue_length() >= self.max_queue_size and not self.stop_thread_pool:
            time.sleep(0.2)
        if not self.stop_thread_pool:
            return_future = self.thread_pool.submit(fn, *args, **kwargs)
            self.add_task_to_queue(return_future)
        return return_future

    def join(self, timeout=None):
        self.thread_pool.shutdown(wait=True)
        self.stop_thread_pool = True
        super().join(timeout=timeout)

    def run(self):
        while not self.stop_thread_pool:
            if self.get_tasks_queue_length() > 0:
                self.check_finished_tasks()
            else:
                time.sleep(0.2)
