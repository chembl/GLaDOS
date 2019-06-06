from glados.ws2es.denormalization import DenormalizationHandler
from glados.ws2es.es_util import DefaultMappings
import glados.ws2es.es_util as es_util
import glados.ws2es.progress_bar_handler as progress_bar_handler


class OrganismDenormalizationHandler(DenormalizationHandler):

    RESOURCE = DenormalizationHandler.AVAILABLE_RESOURCES.ORGANISM

    METADATA_MAPPING = {
        'properties':
        {
            '_metadata':
            {
                'properties':
                {
                    'organism_taxonomy':
                    {
                        'properties':
                        {
                            'l1': DefaultMappings.LOWER_CASE_KEYWORD,
                            'l2': DefaultMappings.LOWER_CASE_KEYWORD,
                            'l3': DefaultMappings.LOWER_CASE_KEYWORD,
                            'l4_synonyms': DefaultMappings.LOWER_CASE_KEYWORD,
                            'oc_id': DefaultMappings.ID_REF,
                            'tax_id': DefaultMappings.ID_REF,
                        }
                    }
                }

            }
        }
    }

    def __init__(self):
        super().__init__()
        self.organism_by_id = {}

    def handle_doc(self, es_doc: dict, total_docs: int, index: int, first: bool, last: bool):
        self.organism_by_id[es_doc['tax_id']] = es_doc

    def complete_data_from_assay_and_target(self):
        tax_id_2_organism = {}
        query_pb = progress_bar_handler.get_new_progressbar(self.RESOURCE.res_name+'-dn-completion',
                                                            len(self.organism_by_id))
        for i, tax_id in enumerate(self.organism_by_id.keys()):
            organisms = set(self.organism_by_id[tax_id]['l4_synonyms'])
            result = es_util.es_conn.search(index=DenormalizationHandler.AVAILABLE_RESOURCES.ASSAY.idx_name, body={
                '_source': 'assay_organism',
                'query': {
                    'term': {
                        'assay_tax_id': {
                            'value': tax_id
                        }
                    }
                }
            })
            for hit_i in result['hits']['hits']:
                organisms.add(hit_i['_source']['assay_organism'])
            result = es_util.es_conn.search(index=DenormalizationHandler.AVAILABLE_RESOURCES.TARGET.idx_name, body={
                '_source': 'organism',
                'query': {
                    'term': {
                        'tax_id': {
                            'value': tax_id
                        }
                    }
                }
            })
            for hit_i in result['hits']['hits']:
                organisms.add(hit_i['_source']['organism'])
            tax_id_2_organism[tax_id] = organisms
            query_pb.update(i)
        query_pb.finish()

        def get_update_script_and_size(doc_id, doc):
            update_doc = {
                'l4_synonyms': list(tax_id_2_organism[doc_id])
            }

            return update_doc, len(tax_id_2_organism[doc_id])

        self.save_denormalization_dict(self.RESOURCE, tax_id_2_organism,
                                       get_update_script_and_size)
