from glados.es.ws2es.util import SummableDict
from glados.es.ws2es.denormalization import DenormalizationHandler
from glados.es.ws2es.denormalization.organism_handler import OrganismDenormalizationHandler


class CellDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.CELL_LINE

    def __init__(self, organism_dh: OrganismDenormalizationHandler=None):
        super().__init__(organism_dh is not None)
        self.organism_dh = organism_dh

    def get_custom_mappings_for_complete_data(self):
        mappings = SummableDict()
        mappings += OrganismDenormalizationHandler.METADATA_MAPPING
        return mappings

    def get_doc_for_complete_data(self, doc: dict):
        update_doc_md = {}

        organism_taxonomy = None
        if self.organism_dh and doc['cell_source_tax_id'] in self.organism_dh.organism_by_id:
            organism_taxonomy = self.organism_dh.organism_by_id[doc['cell_source_tax_id']]
        if organism_taxonomy is not None:
            update_doc_md['organism_taxonomy'] = organism_taxonomy
        return {
            '_metadata': update_doc_md
        }
