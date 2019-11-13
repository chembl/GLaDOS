from elasticsearch_dsl import Search
from elasticsearch_dsl.connections import connections
import json
from elasticsearch_dsl import MultiSearch, Search


def get_classification_json():
    es_conn = connections.get_connection()
    index_name = 'chembl_protein_class'

    body = {
        "size": 0,
        "query": {
            "query_string": {
                "query": "*",
                "analyze_wildcard": True
            }
        },
        "aggs": {
            "children": {
                "terms": {
                    "field": "l1",
                    "size": 1000,
                    "order": {
                        "_count": "desc"
                    }
                },
                "aggs": {
                    "children": {
                        "terms": {
                            "field": "l2",
                            "size": 1000,
                            "order": {
                                "_count": "desc"
                            }
                        },
                        "aggs": {
                            "children": {
                                "terms": {
                                    "field": "l3",
                                    "size": 1000,
                                    "order": {
                                        "_count": "desc"
                                    }
                                },
                                "aggs": {
                                    "children": {
                                        "terms": {
                                            "field": "l4",
                                            "size": 1000,
                                            "order": {
                                                "_count": "desc"
                                            }
                                        },
                                        "aggs": {
                                            "children": {
                                                "terms": {
                                                    "field": "l5",
                                                    "size": 1000,
                                                    "order": {
                                                        "_count": "desc"
                                                    }
                                                },
                                                "aggs": {
                                                    "children": {
                                                        "terms": {
                                                            "field": "l6",
                                                            "size": 1000,
                                                            "order": {
                                                                "_count": "desc"
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    result = es_conn.search(index=index_name, body=body)
    raw_tree_root = result['aggregations']['children']['buckets']

    print('raw_tree_root: ', raw_tree_root)
    print('----')

    final_tree = build_final_tree(raw_tree_root)
    return final_tree


def build_final_tree(raw_tree_root):

    parsed_tree_root = load_tree(raw_tree_root)
    print('parsed_tree_root: ', json.dumps(parsed_tree_root, indent=4))
    load_target_counts(parsed_tree_root)
    return parsed_tree_root


def load_tree(raw_tree_root):

    parsed_tree_root = {}
    for item in raw_tree_root:
        item_id = item['key']
        node = {
            'id': item_id
        }
        parsed_tree_root[item_id] = node

        children = item.get('children')
        if children is not None:
            child_buckets = children.get('buckets')
            if child_buckets is not None:

                if len(child_buckets) > 0:

                    print('going to process: ', child_buckets)
                    node['children'] = load_tree(child_buckets)
                    print('^^^')

    return parsed_tree_root


def generate_count_queries(parsed_tree_root, level=1):

    queries = {}
    for node_id, node in parsed_tree_root.items():
        query_string = '_metadata.protein_classification.l{level}:("{class_name}")'.format(level=level,
                                                                                           class_name=node_id)
        queries[node_id] = {
            'query': query_string
        }
        children = node.get('children')
        if children is not None:
            queries_to_add = generate_count_queries(children, level + 1)
            for key, value in queries_to_add.items():
                queries[key] = value

    return queries


def execute_count_queries(queries):

    print('queries: ', json.dumps(queries, indent=4))
    print('num queries', len(queries.keys()))

    ms = MultiSearch(index='chembl_target')

    target_classes = list(queries.keys())  # be sure to be consistent with the order

    for target_class in target_classes:

        current_query_string = queries[target_class]['query']
        query = {
            "query_string": {
                "_name": current_query_string,
                "query": current_query_string,
            }
        }

        ms = ms.add(Search().query(query))

    responses = ms.execute()

    i = 0
    for response in responses:
        class_name = target_classes[i]
        queries[class_name]['count'] = response.hits.total
        i = i + 1

    return queries


def add_counts_to_tree(queries, nodes_index):

    for class_name, query in queries.items():
        nodes_index[class_name]['target_count'] = query['count']


def get_nodes_index(parsed_tree_root):

    nodes_index = {}
    for node_id, node in parsed_tree_root.items():
        nodes_index[node_id] = node

        children = node.get('children')
        if children is not None:
            nodes_to_add = get_nodes_index(children)

            for key, value in nodes_to_add.items():
                nodes_index[key] = value

    return nodes_index


def load_target_counts(parsed_tree_root):
    print('LOADING TARGET COUNTS')
    nodes_index = get_nodes_index(parsed_tree_root)

    queries = generate_count_queries(parsed_tree_root)
    execute_count_queries(queries)
    add_counts_to_tree(queries, nodes_index)

    print('nodes_index count: ', len(nodes_index.keys()))


