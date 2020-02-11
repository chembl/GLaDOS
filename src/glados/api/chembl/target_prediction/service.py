import requests


def get_target_predictions(molecule_chembl_id):
    smiles = 'C1=CC(=C(C=C1CCN)O)O'
    external_service_request = requests.post('http://hx-rke-wp-webadmin-04-worker-3.caas.ebi.ac.uk:31112/function/mcp',
                                              json={"smiles": smiles})

    external_service_response = external_service_request.json()
    final_response = {
        'predictions': external_service_response
    }
    return final_response
