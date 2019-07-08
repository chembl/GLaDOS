from glados.es.ws2es.denormalization import DenormalizationHandler


class BindingSiteHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.BINDING_SITE

    def __init__(self):
        super().__init__()
        self.binding_sites_by_id = {}

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        binding_site_id = doc['site_id']
        self.binding_sites_by_id[binding_site_id] = doc
