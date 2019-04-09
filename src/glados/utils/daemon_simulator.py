import datetime
import time


def work():
    while True:
        now = datetime.datetime.now()
        print('working...')
        print(now)
        time.sleep(1)
