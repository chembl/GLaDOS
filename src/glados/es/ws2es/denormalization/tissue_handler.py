from glados.es.ws2es.util import SummableDict
from glados.es.ws2es.denormalization import DenormalizationHandler
from glados.es.ws2es.denormalization.assay_handler import AssayDenormalizationHandler
from glados.es.ws2es.denormalization.organism_handler import OrganismDenormalizationHandler


class TissueDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.TISSUE

    def __init__(self, assay_dh: AssayDenormalizationHandler=None, organism_dh: OrganismDenormalizationHandler=None):
        super().__init__(organism_dh is not None or assay_dh is not None)
        self.organism_dh = organism_dh
        self.assay_dh = assay_dh

    def get_custom_mappings_for_complete_data(self):
        mappings = SummableDict()
        mappings += OrganismDenormalizationHandler.METADATA_MAPPING
        return mappings

    def get_doc_for_complete_data(self, doc: dict):
        update_doc_md = {}

        tax_ids = self.assay_dh.tissue_2_tax_id.get(doc['tissue_chembl_id'], [])
        organism_taxonomies = []
        for tax_id_i in tax_ids:
            if self.organism_dh and tax_id_i in self.organism_dh.organism_by_id:
                organism_taxonomies.append(self.organism_dh.organism_by_id[tax_id_i])
        if organism_taxonomies is not None:
            update_doc_md['organism_taxonomy'] = organism_taxonomies
        return {
            '_metadata': update_doc_md
        }
