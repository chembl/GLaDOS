from blessings import Terminal
from progressbar import ProgressBar, Counter, Bar, Percentage, ETA
import glados.es.ws2es.signal_handler as signal_handler
import atexit
from wrapt.decorators import synchronized

PROGRESS_BAR_IDX = 0

term = Terminal()

PROGRESS_BAR_REQUESTED = False


@synchronized
def get_new_progressbar(name, max_val=1) -> ProgressBar:
    global PROGRESS_BAR_IDX, PROGRESS_BAR_REQUESTED
    if PROGRESS_BAR_IDX == 0:
        signal_handler.add_termination_handler(on_exit)
        atexit.register(on_exit, *[None, None])
    PROGRESS_BAR_REQUESTED = True
    if PROGRESS_BAR_IDX == 0:
        print(term.clear)
    writer = Writer((0, PROGRESS_BAR_IDX))
    p_bar = ProgressBar(widgets=[name + ': ', Counter(format='%(value)d out of %(max_value)d'), ' ', Percentage(), ' ', Bar(), ' ', ETA()],
                        fd=writer, max_value=max_val).start(max_value=max_val)
    PROGRESS_BAR_IDX += 1

    return p_bar


def write_after_progress_bars():
    if PROGRESS_BAR_REQUESTED:
        print(term.move(PROGRESS_BAR_IDX, 0)+'\n')


########################################################################################################################


class Writer(object):
    """Create an object with a write method that writes to a
    specific place on the screen, defined at instantiation.
    This is the glue between blessings and progressbar.
    """
    def __init__(self, location):
        """
        Input: location - tuple of ints (x, y), the position
        of the bar in the terminal
        """
        self.location = location

    def write(self, string):
        with term.location(*self.location):
            print(string)


def on_exit(signal, frame):
    write_after_progress_bars()
