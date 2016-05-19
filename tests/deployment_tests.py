import unittest
from django.core.cache import cache
import os

class TestDeployment(unittest.TestCase):

    def test_cache_is_working(self):
      hello_world = 'hello, world!'
      key = 'my_key'
      cache.set(key, hello_world, 10)
      self.assertEqual(cache.get(key), hello_world)


if __name__ == '__main__':
  os.environ['DJANGO_SETTINGS_MODULE'] = 'tests.test_settings'
  print('Testing Deployment!')
  unittest.main()