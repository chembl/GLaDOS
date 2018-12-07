import unittest
import os
from glados import es_connection
import glados.static_files_compiler


class StaticFilesCompilerTester(unittest.TestCase):

    def setUp(self):
        os.environ['DJANGO_SETTINGS_MODULE'] = 'glados.settings'
        es_connection.setup_glados_es_connection()
        print('Running Test: {0}'.format(self._testMethodName))

    def tearDown(self):
        print('Test {0}'.format('Passed!' if self._outcome.success else 'Failed!'))

    def test_compiling_scss(self):
        compiled_correctly = glados.static_files_compiler.StaticFilesCompiler.get_scss_compiler().compile_all()
        self.assertTrue(compiled_correctly, 'Some SCSS files failed to compile correctly!')

    def test_compiling_coffee(self):
        compiled_correctly = glados.static_files_compiler.StaticFilesCompiler.get_coffee_compiler().compile_all()
        self.assertTrue(compiled_correctly, 'Some CoffeeScript files failed to compile correctly!')
