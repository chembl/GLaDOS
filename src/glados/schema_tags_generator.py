from elasticsearch_dsl import Search
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
    do_not_generate_metadata = molecule_type in ['Unclassified']
    if do_not_generate_metadata:
        return get_no_metadata_object()

    molecule_type = response['hits']
    print('molecule_type: ', molecule_type)


    schema_obj = {
        'metadata_generated': True,
        'identifier': chembl_id
    }
    return schema_obj
