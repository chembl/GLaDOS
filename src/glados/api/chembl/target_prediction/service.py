import json

import requests

from glados.usage_statistics import glados_server_statistics


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
    smiles = molecule_structures.get('canonical_smiles')

    return smiles


def get_target_predictions(molecule_chembl_id):
    smiles = get_smiles_from_chembl_id(molecule_chembl_id)
    external_service_request = requests.post('http://hx-rke-wp-webadmin-04-worker-3.caas.ebi.ac.uk:31112/function/mcp',
                                             json={"smiles": smiles})

    external_service_response = external_service_request.json()
    final_response = {
        'predictions': external_service_response
    }
    return final_response
