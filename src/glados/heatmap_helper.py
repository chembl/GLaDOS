# This handles all the functions related to the heatmap helper structure and endpoints.
from . import glados_server_statistics
import json
import sys
import hashlib
import base64
from django.core.cache import cache
from elasticsearch_dsl.connections import connections
from elasticsearch.helpers import streaming_bulk


class HeatmapError(Exception):
    """Base class for exceptions in this file."""
    pass
# ----------------------------------------------------------------------------------------------------------------------
# helper functions
# ----------------------------------------------------------------------------------------------------------------------


def get_item_updates(heatmap_id, items_list, add_related_ids, doc_type):
    """
    This generates the structure that needs to be added in the items for the heatmap
    """
    for item in items_list:
        # print('item: ', item)
        yield {
            '_id': item['id'],
            '_op_type': 'update',
            '_type': doc_type,
            # 'script': 'ctx._source.remove("_heatmap")'
            'doc': {
                '_heatmap_help_test_0': {
                    "{}".format(heatmap_id): {
                        'related_ids': (item['related_ids'] if add_related_ids else None),
                        'footers_counts': item['footers_counts']
                    }
                }
            }
        }


def update_heatmap_data_on_indexes(heatmap_id, heatmap_helper_struct):
    """
    this writes on the involved indexes the heatmap data to help the filtering and sorting processes
    """

    print('update_heatmap_data_on_indexes')
    indexes_to_update = [
        {
            'values': heatmap_helper_struct['rows_index'].values(),
            'add_related_ids': False,
            'index_name': heatmap_helper_struct['rows_es_index_name']
        },
        {
            'values': heatmap_helper_struct['cols_index'].values(),
            'add_related_ids': True,
            'index_name': heatmap_helper_struct['cols_es_index_name']
        }
    ]

    for index_desc in indexes_to_update:
        values = index_desc['values']
        add_related_ids = index_desc['add_related_ids']
        index_name = index_desc['index_name']
        doc_type = index_name.replace('chembl_', '', 1)

        updates = get_item_updates(heatmap_id, values, add_related_ids, doc_type)
        current_es_connection = connections.get_connection()

        # for update in updates:
        #     print('update: ', update)

        num_items = 0
        for ok, result in streaming_bulk(current_es_connection, updates, index=index_name, doc_type=doc_type,
                                         chunk_size=100):
            action, result = result.popitem()
            doc_id = '/%s/doc/%s' % ('chembl_molecule', result['_id'])

            if not ok:
                print('Failed to %s document %s: %r' % (action, doc_id, result))

            else:
                print(doc_id)
                num_items += 1

        print('num_items: ', num_items)



def get_helper_structure(index_name, raw_search_data, aggregations, rows_footers_counts, cols_footers_counts,
                         cells_data_config):
    search_data_digest = hashlib.sha256(raw_search_data.encode('utf-8')).digest()
    base64_search_data_hash = base64.b64encode(search_data_digest).decode('utf-8')
    heatmap_id = "heatmap-test-3-{}-{}".format(index_name, base64_search_data_hash)
    print('heatmap_id:', heatmap_id)

    cache_response = None
    try:
        cache_response = cache.get(heatmap_id)
    except Exception as e:
        raise HeatmapError("Error while processing the aggregation: {}".format(repr(e)))

    if cache_response is not None:
        print('heatmap helper is in cache')
        heatmap_helper_struct = cache_response
    else:
        print('heatmap helper is not in cache')
        heatmap_helper_struct = generate_helper_structure(aggregations, rows_footers_counts, cols_footers_counts,
                                                          cells_data_config)
        update_heatmap_data_on_indexes(heatmap_id, heatmap_helper_struct)
        cache_time = 1
        cache.set(heatmap_id, heatmap_helper_struct, cache_time)

    return heatmap_helper_struct


def generate_helper_structure(aggregations, rows_footers_counts, cols_footers_counts, cells_data_config):
    rows_index = {}
    cols_index = {}
    cells_index = {}
    cells_ranges = {}

    try:
        y_axis_buckets = aggregations['y_axis']['buckets']
        for y_axis_bckt in y_axis_buckets:
            y_item_key = y_axis_bckt['key']

            # get or create row
            current_row = rows_index.get(y_item_key)
            if current_row is None:
                current_row = {
                    'id': y_item_key,
                    'related_ids': [],
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
                # get or create col
                current_col = cols_index.get(x_item_key)
                if current_col is None:
                    current_col = {
                        'id': x_item_key,
                        'related_ids': [],
                        'footers_counts': {
                            'hit_count': 0,
                            #get property name for doc_count
                            "{}".format(doc_count_property): 0
                        }
                    }
                cols_index[x_item_key] = current_col

                # I know that this col has one more hit
                current_col['footers_counts']['hit_count'] += 1

                # Add col id to the related ids of the row
                current_row['related_ids'].append(current_col['id'])

                # Add row id to the related its of the col
                current_col['related_ids'].append(current_row['id'])

                # do the addition that corresponds to the property doc_count
                current_col['footers_counts'][doc_count_property] += x_axis_bckt['doc_count']

                # process every value that comes from custom aggregations
                for x_agg_property in cols_footers_counts['from_x_agg']:
                    if x_agg_property['type'] == 'MAX':
                        prop_name = x_agg_property['prop_name']
                        value = x_axis_bckt[prop_name]['value']
                        current_max_value = current_col['footers_counts'].get(prop_name)

                        if current_max_value is None:
                            current_col['footers_counts'][prop_name] = value
                        elif value is not None:
                            current_col['footers_counts'][prop_name] = max(value,
                                                                          current_col['footers_counts'][prop_name])

                # Now add cell data!
                cell_id = "{}-{}".format(y_item_key, x_item_key)
                new_cell = {
                    'id': cell_id,
                    'col_id': y_item_key,
                    'row_id': x_item_key,
                    "{}".format(doc_count_property): x_axis_bckt['doc_count']
                }
                cells_index[cell_id] = new_cell

                # add data inside each cell
                for x_agg_property in cells_data_config['from_x_agg']:

                    if x_agg_property['type'] in ['MAX', 'AVG']:

                        # add it to the cell data
                        prop_name = x_agg_property['prop_name']
                        value = x_axis_bckt[prop_name]['value']
                        new_cell[prop_name] = value

                        # update heatmap wide ranges
                        current_range_data = cells_ranges.get(prop_name)
                        if not current_range_data:
                            current_range_data = {
                                "min": sys.maxsize,
                                "max": -sys.maxsize -1
                            }
                            cells_ranges[prop_name] = current_range_data

                        if value is not None:
                            if value > current_range_data['max']:
                                current_range_data['max'] = value
                            if value < current_range_data['min']:
                                current_range_data['min'] = value

    except KeyError as e:
        raise HeatmapError("Error while processing the aggregation: {}".format(repr(e)))

    heatmap_helper_struct = {
        'rows_index': rows_index,
        'rows_es_index_name': rows_footers_counts['index_name'],
        'cols_index': cols_index,
        'cols_es_index_name': cols_footers_counts['index_name'],
        'cells_index': cells_index,
        'cells_ranges': cells_ranges
    }
    return heatmap_helper_struct

# ----------------------------------------------------------------------------------------------------------------------
# main functions
# ----------------------------------------------------------------------------------------------------------------------


def generate_heatmap_initial_data(index_name, raw_search_data, raw_cols_footers_counts, raw_rows_footers_counts,
                                  raw_cells_data_config):

    print('generate initial data')
    print('index_name: ', index_name)
    print('raw_search_data: ', raw_search_data)

    cols_footers_counts = json.loads(raw_cols_footers_counts)
    rows_footers_counts = json.loads(raw_rows_footers_counts)
    cells_data_config = json.loads(raw_cells_data_config)

    # get aggregation from elasticsearch
    agg_response = glados_server_statistics.get_and_record_es_cached_response(index_name, raw_search_data)
    aggregations = agg_response.get('aggregations', None)

    if aggregations is None:
        raise HeatmapError('Error while getting heatmap aggregation')

    heatmap_helper_struct = get_helper_structure(index_name, raw_search_data, aggregations, rows_footers_counts,
                                                 cols_footers_counts, cells_data_config)

    # response = connections.get_connection().search(index='chembl_molecule', id='CHEMBL1616766')

    response = {}
    return response

