from glados.api.chembl.dynamic_downloads import jobs
from glados.es.es_properties_configuration import configuration_getter


def queue_download_job(index_name, raw_query, desired_format, context_id):

    download_id = 'hola'
        # get_download_id(index_name, raw_query, desired_format, context_id)
    # parsed_desired_format = desired_format.lower()

    # I am responsible for raw_columns_to_download, id_property

    raw_columns_to_download = '[{"property_name":"molecule_chembl_id","label":"ChEMBL ID"},' \
                              '{"property_name":"pref_name","label":"Name"},' \
                              '{"property_name": "similarity","label": "Similarity","is_contextual": true}]'

    id_property = configuration_getter.get_id_property_for_index(index_name)

    download_job = jobs.queue_new_job(
        index_name=index_name,
        raw_columns_to_download=raw_columns_to_download,
        raw_query=raw_query,
        parsed_desired_format=desired_format.upper(),
        context_id=context_id,
        id_property=id_property
    )

    return download_job.job_id


