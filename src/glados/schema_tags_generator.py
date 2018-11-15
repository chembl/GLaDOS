from elasticsearch_dsl import Search
# This uses elasticsearch to generate helper objects to generate the schema tags of the pages

def get_schema_obj_for_compound(chembl_id):

    q = {
        "query_string": {
            "default_field": "molecule_chembl_id",
            "query": chembl_id
        }
    }
    s = Search(index="chembl_molecule").query(q)
    response = s.execute()
    dont_generate_metadata = response.hits.total == 0

    if dont_generate_metadata:
        schema_obj = {
            'metadata_generated': False
        }
        return schema_obj

    molecule_type = response['hits']
    print('molecule_type: ', molecule_type)


    schema_obj = {
        'metadata_generated': True,
        'identifier': chembl_id
    }
    return schema_obj
