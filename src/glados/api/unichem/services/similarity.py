import requests
import logging
from django.conf import settings
from glados.api.unichem.services.elastic_index import get_multiple_compounds
from urllib.parse import urljoin

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

        unichem_sources = get_sources_from_inchi(compound.get("standardinchikey"))

        # unichem_sources = fetch_sources_unichem(compound.get("standardinchikey"))

        if not bool(unichem_sources):
            unichem_sources = "ERROR"

        similar_compounds.append({
            "uci": similarities[sim_index][0],
            "similarity": similarities[sim_index][1],
            "standardinchi": compound.get("inchi"),
            "standardinchikey": compound.get("standardinchikey"),
            "smiles": compound.get("smiles"),
            "sources": unichem_sources
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


def get_sources_from_inchi(inchikey):

    sources = []

    response = fetch_sources_unichem(inchikey)

    if not bool(response):
        return sources

    for uni_source in response:

        if len(uni_source.get("src_compound_id")) > 1:
            for source_id in uni_source.get("src_compound_id"):

                url = urljoin(uni_source.get("base_id_url"), source_id)
                print(url)
                sources.append({
                    "name": uni_source.get("name"),
                    "nameLabel": uni_source.get("name_label"),
                    "id": source_id,
                    "url": url
                })
        else:
            url = urljoin(uni_source.get("base_id_url"), uni_source.get("src_compound_id")[0])
            sources.append({
                "name": uni_source.get("name"),
                "nameLabel": uni_source.get("name_label"),
                "id": uni_source.get("src_compound_id")[0],
                "url": url
            })

    return sources


def fetch_sources_unichem(inchikey):
    url = "https://www.ebi.ac.uk/unichem/rest/verbose_inchikey/{inchikey}"
    url = url.format(inchikey=inchikey)

    data = {}

    r = requests.get(url)

    if r.ok:
        data = r.json()

    return data
