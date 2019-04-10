from django_rq.queues import get_queue_by_index
from rq.worker import Worker
import time
import sys
import re


def wait_until_workers_are_free():

    worker_name_regex = None
    try:
        worker_name_regex = sys.argv[2]
    except IndexError:
        pass
    while there_are_busy_workers(worker_name_regex):
        time.sleep(1)
    print('No workers are busy right now!')


def there_are_busy_workers(worker_name_regex):

    queue_index = 0
    queue = get_queue_by_index(queue_index)
    workers = Worker.all(queue.connection)

    if worker_name_regex is not None:
        workers = [worker for worker in workers if re.match(worker_name_regex, worker.name)]

    busy_workers = [worker.name for worker in workers if worker.get_state() == 'busy']
    print('busy_workers: ', busy_workers)
    return len(busy_workers) > 0
