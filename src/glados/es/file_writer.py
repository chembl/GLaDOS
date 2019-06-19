from elasticsearch_dsl.connections import connections
from elasticsearch.helpers import scan
from glados.utils.dot_notation_getter import DotNotationGetter
from glados.es.es_properties_configuration import columns_parser
from enum import Enum
import os
from django.conf import settings
import gzip


class OutputFormats(Enum):
    CSV = 'CSV'
    TSV = 'TSV'


class FileWriterError(Exception):
    """Base class for exceptions in the file writer."""
    pass


def get_search_source(columns_to_download):
    return [col['property_name'] for col in columns_to_download]


def format_cell(original_value):
    value = original_value
    if isinstance(value, str):
        value = value.replace('"', "'")

    return '"{}"'.format(value)


def write_separated_values_file(desired_format, index_name, query, columns_to_download, base_file_name,
                                output_dir=settings.DYNAMIC_DOWNLOADS_DIR):
    print('Writing file!')

    if desired_format not in OutputFormats:
        raise FileWriterError('The format {} is not supported'.format(desired_format))

    if index_name is None:
        raise FileWriterError('You must provide an index name')

    if desired_format is OutputFormats.CSV:
        separator = ';'
        file_path = os.path.join(output_dir, base_file_name + '.csv.gz')
    elif desired_format is OutputFormats.TSV:
        separator = '\t'
        file_path = os.path.join(output_dir, base_file_name + '.tsv.gz')

    print('file_path: ')
    print(file_path)

    with gzip.open(file_path, 'wt', encoding='utf-16-le') as out_file:

        all_columns = columns_to_download + []
        header_line = separator.join([format_cell(col['label']) for col in all_columns])
        out_file.write(header_line + '\n')

        es_conn = connections.get_connection()
        source = get_search_source(columns_to_download)

        scanner = scan(es_conn, index=index_name, scroll=u'1m', size=1000, request_timeout=60, query={
            "_source": source,
            "query": query
        })

        for doc_i in scanner:
            doc_source = doc_i['_source']

            dot_notation_getter = DotNotationGetter(doc_source)
            own_properties_to_get = [col['property_name'] for col in columns_to_download]

            own_values = [columns_parser.parse(dot_notation_getter.get_from_string(prop_name), index_name, prop_name)
                          for prop_name in own_properties_to_get]

            contextual_values = []
            all_values = own_values + contextual_values
            item_line = separator.join([format_cell(v) for v in all_values])
            out_file.write(item_line + '\n')

    return file_path
