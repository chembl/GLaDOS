import os
import sys

if __name__ == "__main__":
    os.environ['DJANGO_SETTINGS_MODULE'] = 'glados.settings'

    from django.core.management import execute_from_command_line
    # Compress files before server launch if compression is enabled
    if os.environ.get('RUN_MAIN') != 'true' and len(sys.argv) > 1 and sys.argv[1] == 'runserver':
        import glados.static_files_compiler
        glados.static_files_compiler.StaticFilesCompiler.compile_coffee()
        glados.static_files_compiler.StaticFilesCompiler.compile_scss()
        from django.conf import settings
        if not settings.DEBUG:
            execute_from_command_line([sys.argv[0], 'collectstatic', '--no-input'])
        if settings.COMPRESS_ENABLED and settings.COMPRESS_OFFLINE:
            execute_from_command_line([sys.argv[0], 'compress'])
    execute_from_command_line(sys.argv)
