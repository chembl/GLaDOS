from elasticsearch_dsl import Search
import json
# This uses elasticsearch to generate helper objects to generate the schema tags of the pages
# ------------------------------------------------------------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------------------------------------------------------------


def get_no_metadata_object():
    schema_obj = {
        'metadata_generated': False
    }
    return schema_obj


def get_schema_obj_for_compound(chembl_id):

    q = {
        "query_string": {
            "default_field": "molecule_chembl_id",
            "query": chembl_id
        }
    }
    s = Search(index="chembl_molecule").query(q)
    response = s.execute()

    if response.hits.total == 0:
        return get_no_metadata_object()

    item = response.hits[0]
    molecule_type = item['molecule_type']
    do_not_generate_metadata = molecule_type in ['Unclassified', 'Cell', 'Antibody', 'Enzyme', 'Protein']
    if do_not_generate_metadata:
        return get_no_metadata_object()

    metadata_obj = {
        "@context": "http://schema.org",
        "@type": "MolecularEntity",
        "identifier": chembl_id
    }

    item_name = item['pref_name']
    if item_name is not None:
        metadata_obj['name'] = item['pref_name']

    alternate_names_set = set()
    raw_synonyms = item['molecule_synonyms']
    if raw_synonyms is not None:
        for raw_syn in raw_synonyms:
            alternate_names_set.add(raw_syn['molecule_synonym'])

    alternate_names = list(alternate_names_set)
    if len(alternate_names) > 0:
        metadata_obj['alternateName'] = alternate_names

    schema_obj = {
        'metadata_generated': True,
        'metadata_obj': json.dumps(metadata_obj, indent=2)

    }
    return schema_obj
