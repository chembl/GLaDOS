import os
import sys
import logging.config
import subprocess

def main():
    os.environ['DJANGO_SETTINGS_MODULE'] = 'glados.settings'

    from django.core.management import execute_from_command_line
    from django.conf import settings

    logging.config.dictConfig(settings.LOGGING)

    import glados.static_files_compiler
    import glados.apache_config_generator

    # Compress files before server launch if compression is enabled
    if os.environ.get('RUN_MAIN') != 'true' and len(sys.argv) > 1 and sys.argv[1] == 'runserver' and settings.DEBUG:
        glados.static_files_compiler.StaticFilesCompiler.compile_all_known_compilers()
        execute_from_command_line([sys.argv[0], 'compilemessages'])

        execute_from_command_line(sys.argv)

    elif os.environ.get('RUN_MAIN') != 'true' and len(sys.argv) > 1 and sys.argv[1] == 'collectstatic':
        
        # Builds static Unichem VueJS app
        logging.info(subprocess.check_output(['npm', 'run', 'build'], cwd='src/glados/unichem'))
        
        glados.static_files_compiler.StaticFilesCompiler.compile_all_known_compilers()
        execute_from_command_line([sys.argv[0], 'compilemessages', '--settings=glados'])
        if settings.COMPRESS_ENABLED and settings.COMPRESS_OFFLINE:
            execute_from_command_line([sys.argv[0], 'compress'])

        execute_from_command_line(sys.argv)

    elif os.environ.get('RUN_MAIN') != 'true' and len(sys.argv) > 1 and sys.argv[1] == 'createapacheconfig':

        glados.apache_config_generator.generate_config()



if __name__ == "__main__":
    main()
