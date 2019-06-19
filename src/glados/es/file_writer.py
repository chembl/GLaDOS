from elasticsearch_dsl.connections import connections
from elasticsearch.helpers import scan
from glados.utils.dot_notation_getter import DotNotationGetter
from glados.es.es_properties_configuration import columns_parser

OUTPUT_FORMATS = {
    'CSV': 'CSV',
    'TSV': 'TSV'
}


class FileWriterError(Exception):
    """Base class for exceptions in the file writer."""
    pass


def get_search_source(columns_to_download):
    return [col['property_name'] for col in columns_to_download]


def write_separated_values_file(desired_format, index_name, query, columns_to_download):
    print('Writing file!')

    if desired_format not in OUTPUT_FORMATS.keys():
        raise FileWriterError('The format {} is not supported'.format(desired_format))

    if index_name is None:
        raise FileWriterError('You must provide an index name')

    es_conn = connections.get_connection()
    source = get_search_source(columns_to_download)

    scanner = scan(es_conn, index=index_name, scroll=u'1m', size=1000, request_timeout=60, query={
        "_source": source,
        "query": query
    })

    for doc_i in scanner:
        doc_source = doc_i['_source']
        print('doc_source:')
        print(doc_source)

        dot_notation_getter = DotNotationGetter(doc_source)
        own_properties_to_get = [col['property_name'] for col in columns_to_download]

        own_values = [columns_parser.parse(dot_notation_getter.get_from_string(prop_name), index_name, prop_name)
                      for prop_name in own_properties_to_get]

        print('own_values')
        print(own_values)
        print('^^^')
