import logging

__author__ = 'jfmosquera@ebi.ac.uk'

logger_name = "glados_migration_log"
logger_format = "%(levelname)s:%(message)s"
mig_log = None


def setup_migration_logging(level=logging.INFO):
    global logger_name
    global logger_format
    global mig_log
    # Disables elastic search logging for false positive errors
    logging.basicConfig(level=logging.CRITICAL)
    # create logger
    mig_log = logging.getLogger(logger_name)
    mig_log.setLevel(level)
    mig_log.propagate = False
    # create console handler and set level
    mig_handler = logging.StreamHandler()
    mig_handler.setLevel(level)
    # create formatter
    formatter = logging.Formatter(logger_format)
    # add formatter to handler
    mig_handler.setFormatter(formatter)
    # add handler to logger
    mig_log.addHandler(mig_handler)


def get_logger():
    global mig_log
    return mig_log
