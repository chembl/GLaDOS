import json

import requests
from django.conf import settings
from django.core.cache import cache

from glados.usage_statistics import glados_server_statistics


CACHE_TIME = 60


class TargetPredictionError(Exception):
    """Base class for exceptions in this module."""
    pass


# ----------------------------------------------------------------------------------------------------------------------
# Loading Lookup structure
# ----------------------------------------------------------------------------------------------------------------------
def load_target_prediction_in_training_lookup():

    # The file is generated with this code:  https://colab.research.google.com/drive/1X34vmOnaQZ6o_fhBUqFahK0cC1fSJM4Z
    with open(settings.TARGET_PREDICTION_LOOKUP_FILE, 'r') as lookupfile:
        in_training_lookup = json.load(lookupfile)

    return in_training_lookup

IN_TRAINING_LOOKUP = load_target_prediction_in_training_lookup()


def get_smiles_from_chembl_id(molecule_chembl_id):

    index_name = settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
    es_query = {
        "_source": [
            "molecule_structures.canonical_smiles"
        ],
        "query": {
            "terms": {
                "molecule_chembl_id": [molecule_chembl_id]
            }
        }
    }

    es_response = glados_server_statistics.get_and_record_es_cached_response(index_name, json.dumps(es_query))
    hits = es_response.get('hits').get('hits')
    current_hit = hits[0]
    source = current_hit.get('_source')
    molecule_structures = source.get('molecule_structures')

    if molecule_structures is None:
        raise TargetPredictionError('The compound ' + molecule_chembl_id + ' has no defined structure!')

    smiles = molecule_structures.get('canonical_smiles')

    if smiles is None:
        raise TargetPredictionError('The compound ' + molecule_chembl_id + ' has no defined structure!')

    return smiles


def check_if_in_training(molecule_chembl_id, target_chembl_id):

    trainings_for_mol = IN_TRAINING_LOOKUP.get(molecule_chembl_id)
    if trainings_for_mol is None:
        return False

    return trainings_for_mol.get(target_chembl_id, False)


def get_target_predictions(molecule_chembl_id):

    try:
        smiles = get_smiles_from_chembl_id(molecule_chembl_id)
    except TargetPredictionError as error:

        final_response = {
            'predictions': [],
            'msg': 'No predictions could be returned because of this error: ' + repr(error)
        }
        return final_response

    cache_key = 'target_prediction-{molecule_chembl_id}'.format(molecule_chembl_id=molecule_chembl_id)
    cache_response = cache.get(cache_key)
    if cache_response is not None:
        return cache_response

    external_service_request = requests.post('http://hx-rke-wp-webadmin-04-worker-3.caas.ebi.ac.uk:31112/function/mcp',
                                             json={"smiles": smiles})

    external_service_response = external_service_request.json()
    final_predictions = []


    for raw_prediction in external_service_response:

        target_chembl_id = raw_prediction['target_chemblid']

        parsed_prediction = {
            'target_chembl_id': target_chembl_id,
            'target_pref_name': raw_prediction['pref_name'],
            'target_organism': raw_prediction['organism'],
            'confidence_70': raw_prediction['70%'],
            'confidence_80': raw_prediction['80%'],
            'confidence_90': raw_prediction['90%'],
            'in_training': check_if_in_training(molecule_chembl_id, target_chembl_id)
        }
        final_predictions.append(parsed_prediction)

    final_response = {
        'predictions': final_predictions
    }
    cache.set(cache_key, final_response, CACHE_TIME)
    return final_response
