import traceback

from django.core.cache import cache

from glados.api.chembl.visualisations.shared.tree_generator import TargetHierarchyTreeGenerator


def get_classification_tree():
    cache_key = 'target_classifications_organism_taxonomy_1'
    cache_response = None
    try:
        cache_response = cache.get(cache_key)
    except Exception as e:
        print('Error searching in cache!')

    if cache_response is not None:
        print('results are in cache')
        return cache_response

    index_name = 'chembl_organism'
    es_query = {
        "aggs": {
            "children": {
                "terms": {
                    "field": "l1",
                    "size": 100,
                    "order": {
                        "_count": "desc"
                    }
                },
                "aggs": {
                    "children": {
                        "terms": {
                            "field": "l2",
                            "size": 100,
                            "order": {
                                "_count": "desc"
                            }
                        },
                        "aggs": {
                            "children": {
                                "terms": {
                                    "field": "l3",
                                    "size": 100,
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

    def generate_count_query(path_to_node):

        queries = []
        level = 1
        for node in path_to_node:
            queries.append('_metadata.organism_taxonomy.l{level}:("{class_name}")'.format(level=level, class_name=node))
            level += 1

        return ' AND '.join(queries)

    tree_generator = TargetHierarchyTreeGenerator(index_name=index_name, es_query=es_query,
                                                  query_generator=generate_count_query, count_index='chembl_target')

    final_tree = tree_generator.get_classification_tree()

    try:
        cache_time = int(3.154e7)
        cache.set(cache_key, final_tree, cache_time)
    except Exception as e:
        traceback.print_exc()
        print('Error saving in the cache!')

    return final_tree
