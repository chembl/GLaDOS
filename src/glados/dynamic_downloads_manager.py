# this handles the creation of dynamically generated downloads
import time
from django_rq import job
from django_rq import get_worker

@job
def generate_download_file():

    num = 10
    for i in range(num):
        print('i: ', i)
        time.sleep(1)


def generate_download(index_name, raw_query):
    generate_download_file.delay()
    response = {}
    return response
