import json
import csv

import requests
from django.conf import settings
from django.core.cache import cache

from glados.usage_statistics import glados_server_statistics


class TargetPredictionError(Exception):
    """Base class for exceptions in this module."""
    pass

CACHE_TIME = 3600


def get_smiles_from_chembl_id(molecule_chembl_id):

    index_name = 'chembl_molecule'
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


def get_in_training_lookup_key(molecule_chembl_id, target_chembl_id):

    return 'mol:{molecule}-targ:{target}'.format(molecule=molecule_chembl_id, target=target_chembl_id)


def get_target_prediction_in_training_lookup():

    cache_key = 'target-prediction-in-training-lookup'
    cache_response = cache.get(cache_key)
    if cache_response is not None:
        return cache_response

    in_training_lookup = set()
    with open(settings.TARGET_PREDICTION_LOOKUP_FILE) as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        i = 0
        for row in reader:
            if i != 0:
                target_chembl_id = row[0]
                molecule_chembl_id = row[2]
                lookup_key = get_in_training_lookup_key(molecule_chembl_id, target_chembl_id)
                in_training_lookup.add(lookup_key)
            i += 1

    cache.set(cache_key, in_training_lookup, CACHE_TIME)
    return in_training_lookup


def get_target_predictions(molecule_chembl_id):

    try:

        smiles = get_smiles_from_chembl_id(molecule_chembl_id)

    except TargetPredictionError as error:

        final_response = {
            'predictions': [],
            'msg': 'No predictions could be returned because of this error: ' + repr(error)
        }
        return final_response

    external_service_request = requests.post('http://hx-rke-wp-webadmin-04-worker-3.caas.ebi.ac.uk:31112/function/mcp',
                                             json={"smiles": smiles})

    external_service_response = external_service_request.json()
    target_prediction_lookup = get_target_prediction_in_training_lookup()
    final_predictions = []

    for raw_prediction in external_service_response:

        target_chembl_id = raw_prediction['target_chemblid']
        in_training_lookup_key = get_in_training_lookup_key(molecule_chembl_id, target_chembl_id)
        parsed_prediction = {
            'target_chembl_id': target_chembl_id,
            'target_pref_name': raw_prediction['pref_name'],
            'target_organism': raw_prediction['organism'],
            'confidence_70': raw_prediction['70%'],
            'confidence_80': raw_prediction['80%'],
            'confidence_90': raw_prediction['90%'],
            'in_training': in_training_lookup_key in target_prediction_lookup
        }
        final_predictions.append(parsed_prediction)


    final_response = {
        'predictions': final_predictions
    }
    return final_response
