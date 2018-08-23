from django.conf import settings
import os
import re
import glados
from concurrent import futures
import scss
import coffeescript
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import math
import logging
import hashlib

logger = logging.getLogger('glados.static_files_compiler')


def md5(f_name):
    hash_md5 = hashlib.md5()
    with open(f_name, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()


class FileCompilerEventHandler(FileSystemEventHandler):

    def __init__(self, compile_func):
        super(FileCompilerEventHandler, self).__init__()
        self.compile_func = compile_func

    def on_created(self, event):
        super(FileCompilerEventHandler, self).on_created(event)
        self.compile_func(event)

    def on_modified(self, event):
        super(FileCompilerEventHandler, self).on_modified(event)
        self.compile_func(event)


class StaticFilesCompiler(object):

    # ------------------------------------------------------------------------------------------------------------------
    #  Predefined static files compilers
    # ------------------------------------------------------------------------------------------------------------------

    GLADOS_ROOT = os.path.dirname(os.path.abspath(glados.__file__))

    @staticmethod
    def compile_coffee_bare(file_path):
        return coffeescript.compile_file(file_path, bare=True)

    __COFFEE_COMPILER_INSTANCE = None
    __SCSS_COMPILER_INSTANCE = None

    @classmethod
    def get_coffee_compiler(cls):
        if cls.__COFFEE_COMPILER_INSTANCE is None:
            cls.__COFFEE_COMPILER_INSTANCE = StaticFilesCompiler(
                cls.compile_coffee_bare,
                os.path.join(cls.GLADOS_ROOT, 'static/coffee'),
                os.path.join(cls.GLADOS_ROOT, 'static/js/coffee-gen'),
                '.coffee', '.js'
            )
        return cls.__COFFEE_COMPILER_INSTANCE

    @classmethod
    def get_scss_compiler(cls):
        if cls.__SCSS_COMPILER_INSTANCE is None:
            cls.__SCSS_COMPILER_INSTANCE = StaticFilesCompiler(
                scss.Compiler().compile,
                os.path.join(cls.GLADOS_ROOT, 'static/scss'),
                os.path.join(cls.GLADOS_ROOT, 'static/css/scss-gen'),
                '.scss', '.css', exclude_regex_str=r'^_.*'
            )
        return cls.__SCSS_COMPILER_INSTANCE

    # ------------------------------------------------------------------------------------------------------------------
    #  Compile all known compilers
    # ------------------------------------------------------------------------------------------------------------------

    @classmethod
    def compile_all_known_compilers(cls, start_watchers=settings.WATCH_AND_UPDATE_STATIC_COMPILED_FILES):
        logger.setLevel(logging.INFO)
        coffee_compiler = cls.get_coffee_compiler()
        scss_compiler = cls.get_scss_compiler()
        # Print this warning for coffee compiling
        logger.warning(
            "If coffee static files compilation takes longer than 30 seconds, "
            "please install nodejs to increase compilation speed!"
        )
        compiled_all_coffee_correctly = coffee_compiler.compile_all()
        compiled_all_scss_correctly = scss_compiler.compile_all()
        if start_watchers:
            # Change logging logging to DEBUG if the file watcher is running
            logger.setLevel(logging.DEBUG)
            coffee_compiler.start_watcher()
            scss_compiler.start_watcher()
        return compiled_all_coffee_correctly and compiled_all_scss_correctly

    # ------------------------------------------------------------------------------------------------------------------
    #  Constructor
    # ------------------------------------------------------------------------------------------------------------------

    def __init__(self, compiler_function, src_path, out_path, ext_to_compile, ext_replace, exclude_regex_str=None):
        self.compiler_function = compiler_function
        self.src_path = src_path
        self.out_path = out_path
        self.ext_to_compile = ext_to_compile
        self.ext_replace = ext_replace
        if len(self.ext_replace) > 1 and self.ext_replace[0] != ".":
            self.ext_replace = "."+self.ext_replace
        self.exclude_regex_str = exclude_regex_str
        self.exclude_regex = None
        if self.exclude_regex_str:
            self.exclude_regex = re.compile(self.exclude_regex_str)

    # ------------------------------------------------------------------------------------------------------------------
    #  Methods
    # ------------------------------------------------------------------------------------------------------------------

    def watchdog_event_handler(self, event):
        if not event.is_directory:
            compiled_dir_path = self.get_compiled_path(os.path.dirname(event.src_path))
            compiled_out_path = self.get_compiled_out_path(os.path.basename(event.src_path), compiled_dir_path)
            if compiled_out_path is not None:
                logger.debug("COMPILING: {0}\nINTO: {1}\n...".format(event.src_path, compiled_out_path))
                compilation_stats = self.compile_and_save(event.src_path, compiled_out_path)
                if compilation_stats[1] == 1:
                    logger.error('THIS FILE SHOULD NOT BE PRECOMPILED!')

    def start_watcher(self):
        file_event_handler = FileCompilerEventHandler(self.watchdog_event_handler)
        observer = Observer()
        observer.daemon = True
        observer.schedule(file_event_handler, self.src_path, recursive=True)
        observer.start()
        logger.debug('File watcher started for {} files at {}'.format(self.ext_to_compile, self.src_path))

    @staticmethod
    def should_skip_compile(md5_file_in, file_out):
        exists_out = os.path.exists(file_out + '.src_md5')
        if exists_out:
            with open(file_out + '.src_md5', 'r') as old_md5_file:
                old_md5 = old_md5_file.read()
                return md5_file_in == old_md5
        return False

    def compile_and_save(self, file_in, file_out):
        md5_file_in = md5(file_in)
        if self.should_skip_compile(md5_file_in, file_out):
            logger.debug('SKIPPING COMPILATION: {0} compiled file already exists!'.format(file_in))
            return 0, 1
        try:
            compile_result = self.compiler_function(file_in)
            with open(file_out, 'w') as file_out_i:
                file_out_i.write(compile_result)
            with open(file_out + '.src_md5', 'w') as file_out_i:
                file_out_i.write(md5_file_in)
            logger.debug('COMPILED: {0}'.format(file_in))
            return 1, 0
        except Exception as e:
            try:
                os.remove(file_out)
            except Exception as e:
                logger.error('COMPILATION FAILED: it was not possible to remove previous file!')
            try:
                os.remove(file_out + '.src_md5')
            except Exception as e:
                logger.error('COMPILATION FAILED: it was not possible to remove previous MD5 file!')
            logger.error("Failed to compile file: {0}".format(file_in))
            logger.error(e)
            return 0, 0

    def get_compiled_path(self, dir_path):
        rel_path = os.path.relpath(dir_path, self.src_path)
        compiled_dir_path = os.path.join(self.out_path, rel_path)
        return compiled_dir_path

    def get_compiled_out_path(self, file_src_name, compiled_dir_path):
        file_i_name, file_i_ext = os.path.splitext(file_src_name)
        if file_i_ext != self.ext_to_compile:
            compiled_out_path = None
        else:
            compiled_out_path = os.path.normpath(
                                                  os.path.join(compiled_dir_path,
                                                               file_i_name+self.ext_replace)
                                                 )
        return compiled_out_path

    def compile_all(self):
        import time
        t_ini = time.time()
        tpe_tasks = []
        num_files_to_compile = 0
        with futures.ThreadPoolExecutor(max_workers=5) as tpe:
            logger.info("COMPILING: {0} files.".format(self.ext_to_compile))
            for cur_dir, dirs, files in os.walk(top=self.src_path):
                compiled_dir_path = self.get_compiled_path(cur_dir)
                mkdirs_called = False
                for file_i in files:
                    if self.exclude_regex is not None and self.exclude_regex.match(file_i):
                        logger.debug('EXCLUDED: {0}/{1}'.format(cur_dir, file_i))
                        continue
                    # only create dirs and files if the compilation is successful and the files are not excluded
                    if not mkdirs_called:
                        os.makedirs(compiled_dir_path, exist_ok=True)
                        mkdirs_called = True
                    file_src_i = os.path.join(cur_dir, file_i)
                    compiled_out_path = self.get_compiled_out_path(file_i, compiled_dir_path)
                    if compiled_out_path is not None:
                        num_files_to_compile += 1
                        logger.debug('SUBMITTING: {0}/{1}'.format(cur_dir, file_i))
                        tpe_task = tpe.submit(self.compile_and_save, file_src_i, compiled_out_path)
                        tpe_tasks.append(tpe_task)
            tpe.shutdown(wait=True)

        precompiled_found = 0
        compiled = 0
        for tpe_task_i in tpe_tasks:
            task_stats = tpe_task_i.result()
            compiled += task_stats[0]
            precompiled_found += task_stats[1]
        logger.info(
            "COMPILATION RESULT: {0} precompiled file(s) found and {1} file(s) compiled in {2} second(s)."
            .format(precompiled_found, compiled, math.floor(time.time()-t_ini+1))
        )
        return (precompiled_found + compiled) == num_files_to_compile
