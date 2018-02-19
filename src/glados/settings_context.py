from django.conf import settings


# Additional variables required for the templates
def glados_settings_context_processor(request):
    print('IS SECURE:', request.is_secure(), request.scheme)
    gsc_vars = {
        'request_root_url': request.build_absolute_uri('/'),
        'js_debug': 'true' if settings.DEBUG else 'false'
    }
    print(gsc_vars)
    return gsc_vars
