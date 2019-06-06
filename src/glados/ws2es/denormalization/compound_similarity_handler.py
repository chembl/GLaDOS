
import requests

BASE_EBI_URL = 'https://www.ebi.ac.uk'

similar_molecules = {}
next_url = BASE_EBI_URL+'/chembl/api/data/similarity/CHEMBL1201631/70.json'
while next_url is not None:
  req = requests.get(next_url, verify=False)
  req_data = req.json()
  for molecule_i in req_data['molecules']:
    similar_molecules[molecule_i['molecule_chembl_id']] = molecule_i['similarity']
  if req_data['page_meta']['next']:
    next_url = BASE_EBI_URL+req_data['page_meta']['next']
  else:
    next_url = None


print(len(similar_molecules))
print(similar_molecules)

similar_molecules = {}
next_url = BASE_EBI_URL+'/chembl/api/data/substructure.json?smiles=c1ccc2c(c1)c1ccccc1c1ccccc21'
while next_url is not None:
  req = requests.get(next_url, verify=False)
  req_data = req.json()
  for molecule_i in req_data['molecules']:
    similar_molecules[molecule_i['molecule_chembl_id']] = 100
  if req_data['page_meta']['next']:
    next_url = BASE_EBI_URL+req_data['page_meta']['next']
  else:
    next_url = None

print(len(similar_molecules))
print(similar_molecules)