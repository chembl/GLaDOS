import traceback

from django.core.cache import cache

from src.glados.api.chembl.visualisations.shared.tree_generator import GoSlimTreeGenerator


def get_classification_tree():

    cache_key = 'target_classifications_go_slim_1'
    cache_response = None
    try:
        cache_response = cache.get(cache_key)
    except Exception as e:
        print('Error searching in cache!')

    if cache_response is not None:
        print('results are in cache')
        return cache_response

    tree_generator = GoSlimTreeGenerator()
    final_tree = tree_generator.get_classification_tree()

    try:
        cache_time = int(3.154e7)
        cache.set(cache_key, final_tree, cache_time)
    except Exception as e:
        traceback.print_exc()
        print('Error saving in the cache!')

    return final_tree
