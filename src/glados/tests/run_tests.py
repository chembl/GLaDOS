import os
from glados.es_connection import setup_glados_es_connection, DATA_CONNECTION, MONITORING_CONNECTION

print('RUN TESTS!!')

if __name__ == "__main__" or __name__ == "glados.tests.run_tests":
    os.environ['DJANGO_SETTINGS_MODULE'] = 'glados.settings'
    setup_glados_es_connection(DATA_CONNECTION)
    setup_glados_es_connection(MONITORING_CONNECTION)

    print('starting tests!!')
    from django.core.management import execute_from_command_line
    # 3rd argument is the directory for where to look for tests
    execute_from_command_line(['runtests.py', 'test', 'glados'])
