from django_rq.queues import get_queue_by_index
from rq.worker import Worker


def wait_until_workers_are_free():

    print('Checking if there are any busy workers...')
    # we only have one queue
    queue_index = 0
    queue = get_queue_by_index(queue_index)
    all_workers = Worker.all(queue.connection)
    print('all_workers: ', all_workers)
    workers = [worker for worker in all_workers
               if queue.name in worker.queue_names()]

    print('workers: ', workers)