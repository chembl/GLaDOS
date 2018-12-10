from django.conf import settings
import os

def generate_config():

    template_file_path = os.path.dirname(os.path.dirname(settings.GLADOS_ROOT)) + \
                         '/util/http.d/apache_config_template.txt'

    output_file_path = os.path.dirname(os.path.dirname(settings.GLADOS_ROOT)) + \
                         '/util/http.d/glados.conf'

    with open(template_file_path, 'r') as template_file:

        config_template = template_file.read()
        output = config_template.format(SERVER_BASE_PATH=settings.SERVER_BASE_PATH,
                                        STATIC_DIR=settings.STATIC_ROOT,
                                        DYNAMIC_DOWNLOADS_DIR=settings.DYNAMIC_DOWNLOADS_DIR)

        with open(output_file_path, 'w') as out_file:
            out_file.write(output)
        print('Config file generated in {}'.format(output_file_path))