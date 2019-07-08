from glados.es.ws2es.es_util import DefaultMappings
import glados.es.ws2es.progress_bar_handler as progress_bar_handler
import glados.es.ws2es.signal_handler as signal_handler
import requests
import sys
import zlib

BASE_EBI_URL = 'https://www.ebi.ac.uk'
UNICHEM_FTP_URL = 'http://ftp.ebi.ac.uk/pub/databases/chembl/UniChem/data/wholeSourceMapping/src_id1/src1src{0}.txt.gz'
STOP_LOAD = False


def stop_unichem(signal, frame):
    global STOP_LOAD
    STOP_LOAD = True

signal_handler.add_termination_handler(stop_unichem)

UNICHEM_MAPPING = {
    'properties': {
        '_metadata': {
            'properties': {
                'unichem': {
                    'properties': {
                        'id': DefaultMappings.ID,
                        'src_name': DefaultMappings.KEYWORD,
                        'link': DefaultMappings.NO_INDEX_KEYWORD,
                        'src_url': DefaultMappings.NO_INDEX_KEYWORD,
                    }
                }
            }
        }
    }
}


# noinspection PyBroadException
def load_unichem_ds_desc():
    global STOP_LOAD
    unichem_ds = {}
    try:
        req = requests.get(
            url=BASE_EBI_URL + '/unichem/rest/src_ids/',
            headers={'Accept': 'application/json'},
            timeout=5, verify=False
        )
        json_resp = req.json()
        for ds_i in json_resp:
            if STOP_LOAD:
                return
            ds_id_i = ds_i['src_id']
            req_i = requests.get(url=BASE_EBI_URL + '/unichem/rest/sources/{0}'.format(ds_id_i),
                                 headers={'Accept': 'application/json'}, verify=False)
            unichem_ds[ds_id_i] = req_i.json()[0]
        return unichem_ds
    except:
        import traceback
        traceback.print_exc(file=sys.stderr)
        print('ERROR: UNICHEM data is not available!', file=sys.stderr)
    return unichem_ds


def get_unichem_cross_reference_link_data(src_id: str, cross_reference_id: str, unichem_ds: dict) -> dict:
    link_data = {
        'id': cross_reference_id,
        'link': None,
        'src_name': 'Unknown in UniChem',
        'src_url': 'Unknown in UniChem',
    }
    if src_id in unichem_ds:
        ds = unichem_ds[src_id]
        if ds['base_id_url_available'] == '1':
            link_data['link'] = ds['base_id_url'] + cross_reference_id
        if ds['src_url'] is not None:
            link_data['src_url'] = ds['src_url']
        if ds['name_label'] is not None:
            link_data['src_name'] = ds['name_label']
    return link_data


def collect_unichem_records(src_id: str, records: list, unichem_data_by_chembl_id: dict, unichem_ds_desc: dict):
    for rec_i in records:
        if len(rec_i.strip()) == 0:
            continue
        unichem_ids = rec_i.split('\t')
        if len(unichem_ids) <= 1:
            print('ERROR: Invalid record data \'{0}\' from source {1}'.format(rec_i, src_id), file=sys.stderr)
            continue
        chembl_id = unichem_ids[0]
        if chembl_id.startswith('From src'):
            continue
        if not chembl_id.startswith('CHEMBL'):
            print('ERROR: Invalid ChEMBL ID \'{0}\' from source {1}'.format(chembl_id, src_id), file=sys.stderr)
            continue
        cross_ref_id = unichem_ids[1]
        if chembl_id not in unichem_data_by_chembl_id:
            unichem_data_by_chembl_id[chembl_id] = {'_metadata': {'unichem': []}}
        link_data = get_unichem_cross_reference_link_data(src_id, cross_ref_id, unichem_ds_desc)
        unichem_data_by_chembl_id[chembl_id]['_metadata']['unichem'].append(link_data)


def load_all_chembl_unichem_data():
    global STOP_LOAD
    unichem_ds = load_unichem_ds_desc()
    unichem_data_by_chembl_id = {}
    pb = progress_bar_handler.get_new_progressbar('reading-unichem', len(unichem_ds)-1)

    for i, src_id_i in enumerate(sorted(unichem_ds.keys())):
        if STOP_LOAD:
            return
        if src_id_i == 1 or src_id_i == '1':
            continue
        req_i = requests.get(url=UNICHEM_FTP_URL.format(src_id_i), stream=True, verify=False)
        decoder = zlib.decompressobj(16 + zlib.MAX_WBITS)
        last_row_in_last_chunk = None
        for chunk in req_i.iter_content(chunk_size=1024, decode_unicode=False):
            if STOP_LOAD:
                return
            rows_in_chunk = decoder.decompress(chunk).decode("utf-8")
            if last_row_in_last_chunk:
                rows_in_chunk = last_row_in_last_chunk + rows_in_chunk
            save_last = not rows_in_chunk.endswith('\n')
            records = rows_in_chunk.split('\n')
            if save_last:
                last_row_in_last_chunk = records[-1]
                records = records[:-1]
            else:
                last_row_in_last_chunk = None
            collect_unichem_records(src_id_i, records, unichem_data_by_chembl_id, unichem_ds)
        last_rows = decoder.flush().decode("utf-8")
        if last_row_in_last_chunk:
            last_rows = last_row_in_last_chunk + last_rows
        records = last_rows.split('\n')
        collect_unichem_records(src_id_i, records, unichem_data_by_chembl_id, unichem_ds)
        pb.update(i)
    pb.finish()
    return unichem_data_by_chembl_id
