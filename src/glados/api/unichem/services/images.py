import requests
import logging
import re
from glados.api.unichem.services.elastic_index import get_unichem_compound

logger = logging.getLogger('django')


def get_image_uci(uci):
    compound = get_unichem_compound(uci)

    if compound.get('smiles'):
        return get_svg_from_smile(compound.get('inchi'))

    return ''


def get_svg_from_smile(inchi):
    url = "https://www.ebi.ac.uk/chembl/api/utils/inchi2svg?size={size}"
    url = url.format(size="400")

    data = {}

    r = requests.post(url, inchi)

    if r.ok:
        data = r.content

    # data.replace(b'opacity:1.0', b'opacity:0')

    data = re.sub(b"opacity:1.0", b"opacity:0", data)

    return data
