import requests
import logging
from elasticsearch_dsl import Search
from django.conf import settings
import re

logger = logging.getLogger('django')


def get_similarity(body):

    sim = fetch_similarity(body)
    similar_compounds = []

    for sim_uci in sim:
        unichem_compound = get_unichem_compound(sim_uci[0])

        # Skipping UCIs not found on INDEX
        if not bool(unichem_compound):
            continue

        similar_compounds.append({
            "uci": sim_uci[0],
            "similarity": sim_uci[1],
            "standardinchi": unichem_compound.get("inchi"),
            "standardinchikey": unichem_compound.get("standardinchikey"),
            "smiles": unichem_compound.get("smiles"),
        })

    return similar_compounds


def fetch_similarity(compound):

    url = settings.UNICHEM_SIMILARITY_ENDPOINT
    r = requests.post(url, compound)
    if r.ok:
        similarity = r.json()
    else:
        similarity = {}

    return similarity


def get_unichem_compound(uci):

    q = {
        "terms": {
            "_id": [uci]
        }
    }

    s = Search(index="unichem").query(q)
    response = s.execute()

    compound = {
        "inchi": "",
        "standardinchikey": "",
        "smiles": ""
    }
    if response.hits.total == 1:
        smiles = ""

        if hasattr(response.hits[0], 'smiles'):
            smiles = response.hits[0].smiles
        else:
            logger.warning("No SMILES for UCI %s, check that out", uci)

        compound["inchi"] = response.hits[0].inchi
        compound["standardinchikey"] = response.hits[0].standard_inchi_key
        compound["smiles"] = smiles
    else:
        logger.warning("Compound not found for UCI %s", uci)
        return {}

    return compound


def get_image_uci(uci):

    compound = get_unichem_compound(uci)

    if compound.get('smiles'):
        return get_svg_from_smile(compound.get('smiles'))

    return ''


def get_svg_from_smile(smile):
    url = "https://www.ebi.ac.uk/chembl/api/utils/smiles2svg?size={size}"
    url = url.format(size="250")

    data = {}

    r = requests.post(url, smile)

    if r.ok:
        data = r.content

    # data.replace(b'opacity:1.0', b'opacity:0')

    data = re.sub(b"opacity:1.0", b"opacity:0", data)

    return data


def get_all_compounds():

    response = {'inchis': []}

    q = {
        "query": {
            "exists": {"field": "smiles"}
        }
    }
    s = Search(index="unichem").filter("exists", field="smiles")
    elastic_response = s.execute()

    com = get_unichem_compound('74790025')
    logger.info(com)

    logger.info("Total " + str(elastic_response.hits.total))

    for compound in s:
        smiles = ''

        if hasattr(compound, 'smiles'):
            smiles = compound.smiles

        response['inchis'].append({
            "uci": compound.meta.id,
            "smiles": smiles,
            "similarity": 'LOOL',
            "standardinchi": compound.inchi,
            "standardinchikey": compound.standard_inchi_key,
        })

    return response
