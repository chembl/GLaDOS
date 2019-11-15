import traceback
from django.core.cache import cache
from .shared.tree_generator import TargetHierarchyTreeGenerator


def get_classification_tree():

    cache_key = 'target_classifications_protein_class'
    print('cache_key', cache_key)

    cache_response = None
    try:
        cache_response = cache.get(cache_key)
    except Exception as e:
        print('Error searching in cache!')

    if cache_response is not None:
        print('results are in cache')
        return cache_response

    index_name = 'chembl_protein_class'
    es_query = {
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

    tree_generator = TargetHierarchyTreeGenerator(index_name=index_name, es_query=es_query)
    tree_generator.get_classification_tree()
    final_tree = tree_generator.get_classification_tree()

    try:
        cache_time = 3000000
        cache.set(cache_key, final_tree, cache_time)
    except Exception as e:
        traceback.print_exc()
        print('Error saving in the cache!')

    return final_tree