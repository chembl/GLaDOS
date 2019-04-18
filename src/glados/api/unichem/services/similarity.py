import requests
import logging
from elasticsearch_dsl import Search, Q
from django.conf import settings
import re

logger = logging.getLogger('django')


def get_similarity(body, threshold, init, end):
    similar_compounds = []

    similarities = fetch_similarity(body, threshold)

    if not bool(similarities):
        logger.warning("No similarities found from external endpoint")
        return 0, similar_compounds

    if init > len(similarities):
        return 0, similar_compounds

    compound_ids = []
    for sim_uci in similarities:
        compound_ids.append(str(sim_uci[0]))

    total_count, compounds = get_multiple_compounds(compound_ids, init, end)
    logger.info("Got {} from elastic of {} similarity".format(total_count, len(similarities)))

    for compound in compounds:

        sim_index = next((index for (index, d) in enumerate(similarities) if d[0] == compound.get("uci")), None)
        # Skipping UCIs not found on INDEX
        if sim_index is None:
            logger.warning("Compound not found for UCI %s", compound.get("uci"))
            continue

        similar_compounds.append({
            "uci": similarities[sim_index][0],
            "similarity": similarities[sim_index][1],
            "standardinchi": compound.get("inchi"),
            "standardinchikey": compound.get("standardinchikey"),
            "smiles": compound.get("smiles"),
        })

    return total_count, similar_compounds


def fetch_similarity(compound, threshold):
    url = "{baseurl}/{threshold}".format(
        baseurl=settings.UNICHEM_SIMILARITY_ENDPOINT,
        threshold=threshold
    )
    r = requests.post(url, compound)
    if r.ok:
        similarity = r.json()
    else:
        similarity = {}

    return similarity


def get_multiple_compounds(compound_ids, start, finish):

    q = {
        "ids": {
            "values": compound_ids
        }
    }
    s = Search(index="unichem").query(q)
    s = s[start:finish]
    elastic_response = s.execute()

    compounds = []

    if elastic_response.hits.total >= 1:
        for comp in elastic_response:
            compound = {
                "uci": int(comp.meta.id),
                "inchi": comp.inchi,
                "standardinchikey": comp.standard_inchi_key,
                "smiles": comp.smiles
            }
            compounds.append(compound)
    else:
        logger.warning("No compounds found for %s", compound_ids)
        return 0, {}

    return elastic_response.hits.total, compounds


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


def get_sources_from_inchi(inchikey):
    url = "https://www.ebi.ac.uk/unichem/rest/verbose_inchikey/{inchikey}"
    url = url.format(inchikey=inchikey)

    data = {}

    r = requests.get(url)

    if r.ok:
        data = r.json()

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
