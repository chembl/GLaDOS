import traceback

from django.core.cache import cache
from django.conf import settings

from glados.api.chembl.visualisations.shared.tree_generator import TargetHierarchyTreeGenerator


def get_classification_tree():
    cache_key = 'assay_classifications_in_vivo'
    cache_response = None
    try:
        cache_response = cache.get(cache_key)
    except Exception as e:
        print('Error searching in cache!')

    if cache_response is not None:
        print('results are in cache')
        return cache_response

    index_name = settings.CHEMBL_ES_INDEX_PREFIX+'assay_class'
    es_query = {
        "size": 0,
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
            queries.append('assay_classifications.l{level}:("{class_name}")'.format(level=level,
                                                                                    class_name=node))
            level += 1

        return ' AND '.join(queries)

    tree_generator = TargetHierarchyTreeGenerator(index_name=index_name, es_query=es_query,
                                                  query_generator=generate_count_query,
                                                  count_index=settings.CHEMBL_ES_INDEX_PREFIX+'assay')

    final_tree = tree_generator.get_classification_tree()

    try:
        cache_time = int(3.154e7)
        cache.set(cache_key, final_tree, cache_time)
    except Exception as e:
        traceback.print_exc()
        print('Error saving in the cache!')

    return final_tree
