import unittest
import os
from django.conf import settings

import glados.static_files_compiler


class StaticFilesCompilerTester(unittest.TestCase):

    def setUp(self):
        os.environ['DJANGO_SETTINGS_MODULE'] = 'glados.settings'
        print('ELASTICSEARCH_HOST', settings.ELASTICSEARCH_HOST)
        print('ELASTICSEARCH_USERNAME', settings.ELASTICSEARCH_USERNAME)
        print('ELASTICSEARCH_PASSWORD', settings.ELASTICSEARCH_PASSWORD)
        print('Running Test: {0}'.format(self._testMethodName))

    def tearDown(self):
        print('Test {0}'.format('Passed!' if self._outcome.success else 'Failed!'))

    def test_compiling_scss(self):
        compiled_correctly = glados.static_files_compiler.StaticFilesCompiler.get_scss_compiler().compile_all()
        self.assertTrue(compiled_correctly, 'Some SCSS files failed to compile correctly!')

    def test_compiling_coffee(self):
        compiled_correctly = glados.static_files_compiler.StaticFilesCompiler.get_coffee_compiler().compile_all()
        self.assertTrue(compiled_correctly, 'Some CoffeeScript files failed to compile correctly!')
