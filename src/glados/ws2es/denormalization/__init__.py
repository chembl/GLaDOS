import glados.ws2es.progress_bar_handler as progress_bar_handler
import glados.ws2es.es_util as es_util
import glados.ws2es.resources_description as resources_description
import glados.ws2es.signal_handler as signal_handler
import glados.ws2es.util as util
import math
import sys
from typing import List, Dict, Union

DataCollectorDescription = List[Dict[str, Union[str, bool]]]


class DenormalizationHandler(object):

    AVAILABLE_RESOURCES = resources_description

    REFS_IDS_SLOT_SIZE = 10**4
    RESOURCE = None
    STOP = False

    RELATED_ENTITIES_DYNAMIC_MAPPING = {
        "dynamic_templates": [
            {
                "related_entities_ws_ids": {
                    "path_match": "_metadata.*.all_chembl_ids",
                    "mapping": es_util.DefaultMappings.CHEMBL_ID_REF_AS_WS
                },
            },
            {
                "related_entities_count": {
                    "path_match": "_metadata.*.count",
                    "mapping": es_util.DefaultMappings.INTEGER
                }
            }
        ]
    }

    DENORMALIZATION_CONFIGURATIONS = {

        resources_description.ACTIVITY: {
          'path_to_collect_in': 'related_activities',
          'doc_property': 'activity_id',
          'only_count': True
        },
        resources_description.ASSAY: {
          'path_to_collect_in': 'related_assays',
          'doc_property': 'assay_chembl_id'
        },
        resources_description.CELL_LINE: {
            'path_to_collect_in': 'related_cell_lines',
            'doc_property': 'cell_chembl_id'
        },
        resources_description.DOCUMENT: {
          'path_to_collect_in': 'related_documents',
          'doc_property': 'document_chembl_id'
        },
        resources_description.MOLECULE: {
          'path_to_collect_in': 'related_compounds',
          'doc_property': 'molecule_chembl_id'
        },
        resources_description.TARGET: {
            'path_to_collect_in': 'related_targets',
            'doc_property': 'target_chembl_id'
        },
        resources_description.TISSUE: {
            'path_to_collect_in': 'related_tissues',
            'doc_property': 'tissue_chembl_id'
        },
    }

    @staticmethod
    def stop_denormalization(signal, frame):
        DenormalizationHandler.STOP = True

    def __init__(self, complete_data: bool=False):
        self.complete_data = complete_data
        self.complete_data_pb = None

    def on_doc_for_scan(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        if self.complete_data:
            self.do_complete_data(doc, total_docs, index, first, last)
        self.handle_doc(doc, total_docs, index, first, last)
        return DenormalizationHandler.STOP

    def scan_data_from_es(self, query=None, include_metadata=False):
        if query is None and not include_metadata:
            query = {}
        if not include_metadata:
            util.put_js_path_in_dict(query, '_source.excludes', ['_metadata.*'])
        es_util.scan_index(self.RESOURCE.idx_name, self.on_doc_for_scan, query=query)

    def get_custom_mappings_for_complete_data(self):
        pass

    def get_doc_for_complete_data(self, doc: dict):
        pass

    def handle_doc(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        pass

    def save_denormalization(self):
        pass

    @classmethod
    def update_mappings(cls, new_mappings):
        if new_mappings is not None and cls.RESOURCE is not None:
            es_util.update_doc_type_mappings(cls.RESOURCE.idx_name,
                                             new_mappings)

    def do_complete_data(self, doc: dict, total_docs: int, index: int, first: bool, last: bool):
        if first:
            self.complete_data_pb = progress_bar_handler.get_new_progressbar(
                '{0}-data-completion'.format(self.RESOURCE.idx_name), total_docs
            )
            mappings = self.get_custom_mappings_for_complete_data()
            if len(mappings.keys()) > 0:
                self.update_mappings(mappings)
        update_doc = self.get_doc_for_complete_data(doc)
        if update_doc is not None:
            es_util.update_doc_bulk(self.RESOURCE.idx_name, self.RESOURCE.get_doc_id(doc),
                                    doc=update_doc)

        es_util.bulk_submitter.set_complete_futures(True)

        if last:
            es_util.bulk_submitter.finish_current_queues()
            es_util.bulk_submitter.set_complete_futures(False)
            self.complete_data_pb.finish()
        else:
            self.complete_data_pb.update(index)

    @staticmethod
    def collect_data(doc: dict, data_collect_dict: dict, id_property: str,
                     data_collection_description: DataCollectorDescription):
        key_id = doc[id_property]
        if not key_id:
            return
        if key_id not in data_collect_dict:
            data_collect_dict[key_id] = {}

        for desc_i in data_collection_description:
            path_to_collect_in = desc_i.get('path_to_collect_in')
            doc_property = desc_i.get('doc_property')
            collected_values_path = 'all_chembl_ids'
            only_count = desc_i.get('only_count', False)
            unique_values = desc_i.get('unique_values', True)

            value = doc[doc_property]

            if not value:
                continue

            if path_to_collect_in not in data_collect_dict[key_id]:
                data_collect_dict[key_id][path_to_collect_in] = {'count': 0}
                if not only_count:
                    data_collect_dict[key_id][path_to_collect_in][collected_values_path] = \
                        set() if unique_values else []

            if only_count or not unique_values or (
                        unique_values and
                        (value not in data_collect_dict[key_id][path_to_collect_in][collected_values_path])
                    ):
                data_collect_dict[key_id][path_to_collect_in]['count'] += 1
                if unique_values and not only_count:
                    data_collect_dict[key_id][path_to_collect_in][collected_values_path].add(value)
                elif not only_count:
                    data_collect_dict[key_id][path_to_collect_in][collected_values_path].append(value)

    @classmethod
    def list_to_multi_list_dict(cls, list_2_convert: list):
        count = 0
        cur_slot_index = math.floor(count / cls.REFS_IDS_SLOT_SIZE)
        multi_list_dict = {}
        while len(list_2_convert) > 0:
            num_to_fill_slot = int((cur_slot_index + 1) * cls.REFS_IDS_SLOT_SIZE) - count
            multi_list_dict[str(cur_slot_index)] = list_2_convert[:num_to_fill_slot]

            # Next Slot
            list_2_convert = list_2_convert[num_to_fill_slot:]
            count += num_to_fill_slot
            cur_slot_index += 1

        return multi_list_dict

    @classmethod
    def submit_docs_collected_data(cls, entity_dict_s: dict,
                                   resource_desc: resources_description.ResourceDescription):

        es_util.update_doc_type_mappings(resource_desc.idx_name,
                                         cls.RELATED_ENTITIES_DYNAMIC_MAPPING)
        sys.stderr.flush()

        def get_update_script_and_size(es_doc_id: str, dn_dict: dict):
            update_size = 0

            update_doc = {
                '_metadata': dn_dict
            }
            for related_data_i in dn_dict:
                for prop_j in dn_dict[related_data_i]:
                    if type(dn_dict[related_data_i][prop_j]) == set:
                        dn_dict[related_data_i][prop_j] = list(dn_dict[related_data_i][prop_j])

                    if type(dn_dict[related_data_i][prop_j]) == list:
                        dn_dict[related_data_i][prop_j] = ' '.join(dn_dict[related_data_i][prop_j])
                        update_size += len(dn_dict[related_data_i][prop_j])
                    else:
                        update_size += 1
                # dn_dict[related_data_i]['chembl_ids'] = None

            return update_doc, update_size

        cls.save_denormalization_dict(resource_desc, entity_dict_s, get_update_script_and_size)

    @staticmethod
    def default_update_script_and_size(doc_id, es_doc):
        return es_doc, util.count_fields_in_doc(es_doc)

    @classmethod
    def save_denormalization_dict(cls, resource_desc: resources_description.ResourceDescription, dn_dict: dict,
                                  get_update_script_and_size, new_mappings=None, do_index=False):
        if new_mappings:
            es_util.update_doc_type_mappings(resource_desc.idx_name,
                                             new_mappings)

        progressbar_name = '{0}-dn-{1}'.format(cls.RESOURCE.res_name, resource_desc.res_name)
        doc_ids = list(dn_dict.keys())
        p_bar = progress_bar_handler.get_new_progressbar(progressbar_name, len(dn_dict))
        entity_dn_count = 0
        for doc_id_i in doc_ids:
            if DenormalizationHandler.STOP:
                return

            update_doc, update_size = get_update_script_and_size(doc_id_i, dn_dict[doc_id_i])
            # Indexes instead of update if it is requested
            if do_index:
                es_util.index_doc_bulk(
                    resource_desc.idx_name,
                    doc_id_i,
                    update_doc
                )
            else:
                es_util.update_doc_bulk(resource_desc.idx_name,
                                        doc_id_i,
                                        doc=update_doc)

            entity_dn_count += 1
            p_bar.update(entity_dn_count)

        es_util.bulk_submitter.finish_current_queues()

        p_bar.finish()


signal_handler.add_termination_handler(DenormalizationHandler.stop_denormalization)
