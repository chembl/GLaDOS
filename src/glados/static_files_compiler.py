# from django.conf import settings
import os
import re
import glados
from concurrent import futures
import scss
import coffeescript

GLADOS_ROOT = os.path.dirname(os.path.abspath(glados.__file__))
COFFEE_PATH = os.path.join(GLADOS_ROOT, 'static/coffee')
COFFEE_GEN_PATH = os.path.join(GLADOS_ROOT, 'static/js/coffee-gen')


def compile_coffee_bare(file_path):
    return coffeescript.compile_file(file_path, bare=True)

COFFEE_COMPILE_FUNC = compile_coffee_bare

SCSS_PATH = os.path.join(GLADOS_ROOT, 'static/scss')
SCSS_GEN_PATH = os.path.join(GLADOS_ROOT, 'static/css/scss-gen')
SCSS_COMPILE_FUNC = scss.Compiler().compile


class StaticFilesCompiler(object):

    def __init__(self, compiler_function, src_path, out_path, ext_replace, exclude_regex_str=None):
        self.compiler_function = compiler_function
        self.src_path = src_path
        self.out_path = out_path
        self.ext_replace = ext_replace
        if len(self.ext_replace) > 1 and self.ext_replace[0] != ".":
            self.ext_replace = "."+self.ext_replace
        self.exclude_regex_str = exclude_regex_str
        self.exclude_regex = None
        if self.exclude_regex_str:
            self.exclude_regex = re.compile(self.exclude_regex_str)
        # self.watch = settings.WATCH_AND_UPDATE_STATIC_COMPILED_FILES
        # if self.watch:
        #     self.start_watchers()

    def start_watchers(self):
        pass

    def compile_and_save(self, file_in, file_out):
        try:
            compile_result = self.compiler_function(file_in)
            with open(file_out, 'w') as file_out_i:
                file_out_i.write(compile_result)
        except Exception as e:
            print(e)
            print("WARNING: Failed to compile file: {0}".format(file_in))

    def compile_all(self):
        import time
        t_ini = time.time()
        with futures.ThreadPoolExecutor(max_workers=5) as tpe:
            for cur_dir, dirs, files, root_fd in os.fwalk(top=self.src_path):
                rel_path = os.path.relpath(cur_dir, self.src_path)
                compiled_dir_path = os.path.join(self.out_path, rel_path)
                mkdirs_called = False
                for file_i in files:
                    if self.exclude_regex is not None and self.exclude_regex.match(file_i):
                        continue
                    # only create dirs and files if the compilation is successful and the files are not excluded
                    if not mkdirs_called:
                        os.makedirs(compiled_dir_path, exist_ok=True)
                        mkdirs_called = True
                    file_src_i = os.path.join(cur_dir, file_i)
                    file_i_name, file_i_ext = os.path.splitext(file_i)
                    compiled_out_path = os.path.normpath(
                                                          os.path.join(compiled_dir_path,
                                                                       file_i_name + self.ext_replace)
                                                         )
                    tpe.submit(self.compile_and_save, file_src_i, compiled_out_path)
            tpe.shutdown(wait=True)
            print(time.time()-t_ini)


def compile_coffee():
    comp = StaticFilesCompiler(COFFEE_COMPILE_FUNC, COFFEE_PATH, COFFEE_GEN_PATH, 'js')
    comp.compile_all()


def compile_scss():
    comp = StaticFilesCompiler(SCSS_COMPILE_FUNC, SCSS_PATH, SCSS_GEN_PATH, '.css', exclude_regex_str="^_.*")
    comp.compile_all()
