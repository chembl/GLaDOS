import traceback
import sys
import requests
import glados.es.ws2es.es_util as es_util
from requests.packages.urllib3.exceptions import InsecureRequestWarning
from glados.es.ws2es.util import SharedThreadPool
from glados.es.ws2es.resources_description import MOLECULE
import glados.es.ws2es.progress_bar_handler as progress_bar_handler
import glados.es.ws2es.signal_handler as signal_handler
import os


requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

BASE_WS_URL = 'http://wwwdev.ebi.ac.uk/chembl/api/data/molecule/'
WS_REQUEST_POOL = SharedThreadPool(max_workers=10, label='MOL File Helper')
WS_REQUEST_POOL.start()
CACHING_PB = None
CACHING_PB_COUNT = 0
SDF_CACHE = {}
STOP_SCAN = False
BASE_CACHE_PATH = os.path.join(os.getcwd(), 'sdf-files-cache')
os.makedirs(BASE_CACHE_PATH, exist_ok=True)


def stop_scan(signal, frame):
    global STOP_SCAN
    STOP_SCAN = True
    es_util.stop_scan(signal, frame)


signal_handler.add_termination_handler(stop_scan)


def get_sdf_by_chembl_id(molecule_chembl_id):
    global BASE_WS_URL, CACHING_PB, CACHING_PB_COUNT, SDF_CACHE, STOP_SCAN, BASE_CACHE_PATH
    if STOP_SCAN:
        return None
    cached_file_path = os.path.join(BASE_CACHE_PATH, molecule_chembl_id+'.sdf')
    if molecule_chembl_id in SDF_CACHE:
        return SDF_CACHE[molecule_chembl_id]
    elif os.path.exists(cached_file_path):
        try:
            with open(cached_file_path, 'r', encoding='utf-8') as cached_file:
                mol_file = cached_file.read()
                if mol_file.strip() == "":
                    return None
                SDF_CACHE[molecule_chembl_id] = mol_file
                if CACHING_PB:
                    CACHING_PB_COUNT += 1
                    CACHING_PB.update(CACHING_PB_COUNT)
                return mol_file
        except:
            traceback.print_exc()
            print('FOUND FILE AT {0} BUT WAS UNABLE TO READ IT!'.format(cached_file_path), file=sys.stderr)
    try:
        file_utf_8 = None
        req = requests.get(BASE_WS_URL+molecule_chembl_id+'.sdf', verify=False)
        if CACHING_PB:
            CACHING_PB_COUNT += 1
            CACHING_PB.update(CACHING_PB_COUNT)
        if req.status_code == 404:
            file_utf_8 = None
        elif req.status_code == 200:
            file_utf_8 = req.content.decode("utf-8")
        else:
            raise Exception('ERROR! Unexpected code {0} for {1}.'.format(req.status_code, molecule_chembl_id))
        SDF_CACHE[molecule_chembl_id] = file_utf_8
        try:
            with open(cached_file_path, 'w', encoding='utf-8') as cached_file:
                if file_utf_8:
                    cached_file.write(file_utf_8)
                else:
                    cached_file.write('')
        except:
            traceback.print_exc()
            print('UNABLE TO WRITE FILE AT {0}'.format(cached_file_path), file=sys.stderr)
        return file_utf_8
    except Exception as e:
        print('ERROR: unexpected error occurred when fetching {0}.sdf'.format(molecule_chembl_id), file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
        return None


def pre_cache_sdf_files():
    global CACHING_PB, CACHING_PB_COUNT, WS_REQUEST_POOL, SDF_CACHE
    CACHING_PB = progress_bar_handler.get_new_progressbar(
      'molecule_sdf_caching', max_val=es_util.get_idx_count(MOLECULE.idx_name)
    )
    CACHING_PB_COUNT = 0

    def __handle_molecule_doc(doc, *args, **kargs):
        if not STOP_SCAN:
            WS_REQUEST_POOL.submit(get_sdf_by_chembl_id, doc['molecule_chembl_id'])
    es_util.scan_index(
        MOLECULE.idx_name, on_doc=__handle_molecule_doc,
        query={
            '_source': 'molecule_chembl_id',
            'query': {
                'query_string': {
                    'query': '*'
                }
            }
        })
    WS_REQUEST_POOL.join()
    CACHING_PB.finish()
    print('SDF data has been cached for {0} CHEMBL IDS'.format(len(SDF_CACHE)), file=sys.stderr)
    sdfs_to_print = 5
    for key_i in SDF_CACHE.keys():
        if SDF_CACHE[key_i]:
            print('SDF file for {0}:'.format(key_i), file=sys.stderr)
            print('====>'+SDF_CACHE[key_i].replace('\n', '\n====>')+'\n', file=sys.stderr)
            sdfs_to_print -= 1
            if sdfs_to_print == 0:
                break


if __name__ == '__main__':
    es_util.setup_connection('wp-p2m-95.ebi.ac.uk', 9200)
    pre_cache_sdf_files()
