import os
from glados import es_connection

print('RUN TESTS!!')

if __name__ == "__main__" or __name__ == "glados.tests.run_tests":
    os.environ['DJANGO_SETTINGS_MODULE'] = 'glados.settings'
    es_connection.setup_glados_es_connection()

    print('starting tests!!')
    from django.core.management import execute_from_command_line
    # 3rd argument is the directory for where to look for tests
    execute_from_command_line(['runtests.py', 'test', 'glados.es_properties_configuration.tests'])
    execute_from_command_line(['runtests.py', 'test', 'glados.tests'])
