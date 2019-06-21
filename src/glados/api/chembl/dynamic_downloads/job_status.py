from datetime import datetime, timedelta, timezone
import socket
from glados.api.chembl.dynamic_downloads.models import DownloadJob


def format_log_message(msg):
    now = datetime.now()
    return "[{date}] {hostname}: {msg}\n".format(date=now, hostname=socket.gethostname(), msg=msg)


def append_to_job_log(download_job, msg):
    if download_job.log is None:
        download_job.log = ''

    download_job.log += format_log_message(msg)
    download_job.save()


def save_download_job_state(download_job, new_state):
    download_job.status = new_state
    if new_state == DownloadJob.FINISHED:
        dt = datetime.now()
        td = timedelta(days=7)
        expiration_date = dt + td
        expiration_date.replace(tzinfo=timezone.utc)
        download_job.expires = expiration_date
    download_job.save()
