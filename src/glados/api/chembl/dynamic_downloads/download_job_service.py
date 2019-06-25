def queue_download_job(index_name, raw_query, desired_format, context_id):

    response = {}
    download_id = 'hola'
        # get_download_id(index_name, raw_query, desired_format, context_id)
    # parsed_desired_format = desired_format.lower()

    # I am responsible for raw_columns_to_download, id_property

    raw_columns_to_download = '[{"property_name":"molecule_chembl_id","label":"ChEMBL ID"},' \
                              '{"property_name":"pref_name","label":"Name"},' \
                              '{"property_name": "similarity","label": "Similarity","is_contextual": true}]'
    id_property = 'molecule_chembl_id'

    response['download_id'] = download_id
    return response


