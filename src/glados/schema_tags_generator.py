from elasticsearch_dsl import Search
# This uses elasticsearch to generate helper objects to generate the schema tags of the pages

def get_schema_obj_for_compound(chembl_id):

    schema_obj = {
        'identifier': chembl_id
    }
    return schema_obj
