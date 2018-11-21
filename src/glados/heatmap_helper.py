# This handles all the functions related to the heatmap helper structure and endpoints.
from . import glados_server_statistics
import json


class HeatmapError(Exception):
    """Base class for exceptions in this file."""
    pass
# ----------------------------------------------------------------------------------------------------------------------
# helper functions
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# main functions
# ----------------------------------------------------------------------------------------------------------------------


def generate_heatmap_initial_data(index_name, raw_search_data, raw_cols_footers_counts, raw_rows_footers_counts):

    print('generate initial data')
    print('index_name: ', index_name)
    print('raw_search_data: ', raw_search_data)

    cols_footers_counts = json.loads(raw_cols_footers_counts)
    rows_footers_counts = json.loads(raw_rows_footers_counts)

    # get aggregation from elasticsearch
    agg_response = glados_server_statistics.get_and_record_es_cached_response(index_name, raw_search_data)
    aggregations = agg_response.get('aggregations', None)

    if aggregations is None:
        raise HeatmapError('Error while getting heatmap aggregation')

    print('aggregations: ', aggregations)
    rows_index = {}
    cols_index = {}
    cells_index = {}

    try:
        y_axis_buckets = aggregations['y_axis']['buckets']
        for y_axis_bckt in y_axis_buckets:
            y_item_key = y_axis_bckt['key']
            print('---')
            print('y_item_key: ', y_item_key)

            # get or create row
            current_row = rows_index.get(y_item_key)
            if current_row is None:
                current_row = {
                    'id': y_item_key,
                    'footers_counts': {}
                }
                rows_index[y_item_key] = current_row

            for y_agg_property in rows_footers_counts['from_y_agg']:
                if y_agg_property['type'] == 'MAX':
                    prop_name = y_agg_property['prop_name']
                    value = y_axis_bckt[prop_name]['value']
                    current_row['footers_counts'][prop_name] = value

            x_axis_buckets = y_axis_bckt['x_axis']['buckets']
            for x_axis_bckt in x_axis_buckets:
                x_item_key = x_axis_bckt['key']
                doc_count_property = cols_footers_counts['doc_count']
                print('x_item_key: ', x_item_key)
                # get or create col
                current_col = cols_index.get(x_item_key)
                if current_col is None:
                    current_col = {
                        'id': x_item_key,
                        'footer_counts': {
                            'hit_count': 0,
                            #get property name for doc_count
                            "{}".format(doc_count_property): 0
                        }
                    }
                cols_index[x_item_key] = current_col

                # I know that this col has one more hit
                current_col['footer_counts']['hit_count'] += 1

                # do the addition that corresponds to the property doc_count
                current_col['footer_counts'][doc_count_property] += x_axis_bckt['doc_count']

                print('x_axis_bckt: ', x_axis_bckt)
                # process every value that comes from custom aggregations
                for x_agg_property in cols_footers_counts['from_x_agg']:
                    if x_agg_property['type'] == 'MAX':
                        prop_name = x_agg_property['prop_name']
                        value = x_axis_bckt[prop_name]['value']
                        current_max_value = current_col['footer_counts'].get(prop_name)

                        if current_max_value is None:
                            current_col['footer_counts'][prop_name] = value
                        elif value is not None:
                            current_col['footer_counts'][prop_name] = max(value,
                                                                          current_col['footer_counts'][prop_name])

            print()
    except KeyError as e:
        raise HeatmapError("Error while processing the aggregation: {}".format(repr(e)))

    print('rows_index', rows_index)
    print('cols_index', cols_index)

    response = {}
    return response

