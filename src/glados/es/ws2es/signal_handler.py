from typing import Callable
import signal
import sys

__author__ = 'jfmosquera@ebi.ac.uk'

########################################################################################################################

HANDLERS = []


def add_termination_handler(handler: Callable):
    return # TODO: this must be refactored to work with the GLaDOS server smoothly
    global HANDLERS
    if len(HANDLERS) == 0:
        signal.signal(signal.SIGTERM, termination_handler)
        signal.signal(signal.SIGINT, termination_handler)
    if handler:
        HANDLERS.append(handler)


def termination_handler(stop_signal, frame):
    return
    global HANDLERS
    print('WARNING! TERMINATION INVOKED!', file=sys.stderr)
    sys.stderr.flush()
    for handler_i in HANDLERS:
        handler_i(stop_signal, frame)
