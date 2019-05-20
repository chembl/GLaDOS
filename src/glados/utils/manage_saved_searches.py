from datetime import datetime, timezone
import sys


def delete_expired_searches():

    dry_run = '--dry-run' in sys.argv
    delete_unexpirable = '--deleteunexpirable' in sys.argv
    print('deleteunexpirable: ', delete_unexpirable)
    now = datetime.utcnow().replace(tzinfo=timezone.utc)