from django.conf import settings


# Additional variables required for the templates
def glados_settings_context_processor(request):
    gsc_vars = {
        'request_root_url': request.build_absolute_uri('/'),
        'js_debug': 'true' if settings.DEBUG else 'false',
        'ws_url': settings.WS_URL,
        'beaker_url': settings.BEAKER_URL,
        'chembl_es_index_prefix': settings.CHEMBL_ES_INDEX_PREFIX,
        'es_url': settings.ELASTICSEARCH_EXTERNAL_URL,
    }
    return gsc_vars
