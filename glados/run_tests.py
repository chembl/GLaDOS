import os

if __name__ == "__main__":
  os.environ['DJANGO_SETTINGS_MODULE'] = 'tests.test_settings'

  print('starting tests!!')
  from django.core.management import execute_from_command_line
  execute_from_command_line(['runtests.py', 'test'])