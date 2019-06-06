import requests
import sys
import traceback

XREFS_DS_DATA = None
XREFS_DS_URL = 'http://wwwdev.ebi.ac.uk/chembl/api/data/xref_source.json?limit=100'


# noinspection PyBroadException
def get_x_ref_url(x_ref_ds_name, x_ref_id):
    global XREFS_DS_DATA
    if x_ref_ds_name in XREFS_DS_DATA:
        try:
            return XREFS_DS_DATA[x_ref_ds_name]['xref_id_url'].replace('$$', x_ref_id)
        except:
            return None
    return None


def complete_xrefs(x_refs):
    if x_refs is None:
        return
    for x_ref_i in x_refs:
        xref_src = x_ref_i.get('xref_src', None)
        if xref_src is None:
            xref_src = x_ref_i.get('xref_src_db', None)
        if xref_src is None:
            print('ERROR! missing xref_src or xref_src_db field in cross references: {0}'.format(x_ref_i),
                  file=sys.stderr)
            return

        x_ref_i['xref_url'] = get_x_ref_url(xref_src, x_ref_i['xref_id'])
        x_ref_i['xref_src_url'] = XREFS_DS_DATA.get(xref_src, {}).get('xref_src_url', None)


def load_x_refs_data():
    global XREFS_DS_DATA, XREFS_DS_URL
    XREFS_DS_DATA = {}
    try:
        req = requests.get(
            url=XREFS_DS_URL,
            headers={'Accept': 'application/json'},
            timeout=5,
            verify=False
        )
        json_resp = req.json()
        for xref_ds in json_resp['xref_sources']:
            XREFS_DS_DATA[xref_ds['xref_src_db']] = xref_ds
    except:
        traceback.print_exc(file=sys.stderr)
        print('ERROR: X-REFS data is not available!', file=sys.stderr)


if XREFS_DS_DATA is None:
    load_x_refs_data()
