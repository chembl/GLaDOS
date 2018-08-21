import copy
import logging


class ColoredConsoleHandler(logging.StreamHandler):
    def emit(self, record):
        # Need to make a actual copy of the record
        # to prevent altering the message for other loggers
        myrecord = copy.copy(record)
        levelno = myrecord.levelno
        if levelno >= 50:  # CRITICAL / FATAL
            color = '\x1b[31m'  # red
        elif levelno >= 40:  # ERROR
            color = '\x1b[31m'  # red
        elif levelno >= 30:  # WARNING
            color = '\x1b[33m'  # yellow
        elif levelno >= 20:  # INFO
            color = '\x1b[32m'  # green
        elif levelno >= 10:  # DEBUG
            color = '\x1b[35m'  # pink
        else:  # NOTSET and anything else
            color = '\x1b[0m'  # normal
        myrecord.msg = color + str(myrecord.msg) + '\x1b[0m'  # normal
        logging.StreamHandler.emit(self, myrecord)


class MultiLineFormatter(logging.Formatter):
    def format(self, record):
        log_text = logging.Formatter.format(self, record)
        header, footer = log_text.split(record.message)
        log_text = log_text.replace('\n', '\n' + ' ' * len(header))
        return log_text
