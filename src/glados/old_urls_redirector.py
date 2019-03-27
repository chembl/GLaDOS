from django.core.urlresolvers import reverse
from django.http import HttpResponsePermanentRedirect


ENTITY_NAME_TO_URL_NAME = {
    'compound': 'compound_report_card',
    'target': 'target_report_card',
    'assay': 'assay_report_card',
    'doc': 'document_report_card',
    'cell': 'cell_line_report_card',
    'tissue': 'tissue_report_card'
}


def redirect_report_card(request, entity_name, chembl_id,):
    url_name = ENTITY_NAME_TO_URL_NAME[entity_name]
    return HttpResponsePermanentRedirect(reverse(url_name, args=[chembl_id.upper()]))