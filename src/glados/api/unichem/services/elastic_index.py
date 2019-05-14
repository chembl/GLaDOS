import logging

from elasticsearch_dsl import Search

logger = logging.getLogger('django')


def get_multiple_compounds(compound_ids):

    q = {
        "ids": {
            "values": compound_ids
        }
    }
    s = Search(index="unichem").query(q)
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


def get_multiple_compounds_range(compound_ids, start, finish):

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
