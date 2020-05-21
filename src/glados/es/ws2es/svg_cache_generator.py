import traceback
import sys
import requests
from glados.es.ws2es.es_util import es_util
from requests.packages.urllib3.exceptions import InsecureRequestWarning
from glados.es.ws2es.util import SharedThreadPool
from glados.es.ws2es.resources_description import MOLECULE
import glados.es.ws2es.progress_bar_handler as progress_bar_handler
import glados.es.ws2es.signal_handler as signal_handler
import os
import json
from wrapt.decorators import synchronized


requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

BASE_WS_URL = 'http://wwwdev.ebi.ac.uk/chembl/api/data/molecule/'
WS_REQUEST_POOL = SharedThreadPool(max_workers=10, label='SVG File benchmarker')
WS_REQUEST_POOL.start()
CACHING_PB = None
CACHING_PB_COUNT = 0
RDKIT_CACHE = {}
INDIGO_CACHE = {}
SVG_FAILURES = {}
STOP_SCAN = False
BASE_CACHE_PATH = os.path.join(os.getcwd(), 'svg-files-cache')
os.makedirs(BASE_CACHE_PATH, exist_ok=True)


def stop_scan(signal, frame):
    global STOP_SCAN
    STOP_SCAN = True
    es_util.stop_scan(signal, frame)


signal_handler.add_termination_handler(stop_scan)


@synchronized
def register_fail(molecule_chembl_id, framework):
    global SVG_FAILURES
    if molecule_chembl_id not in SVG_FAILURES:
        SVG_FAILURES[molecule_chembl_id] = []
    SVG_FAILURES[molecule_chembl_id].append(framework)


def get_svg_by_chembl_id(molecule_chembl_id, indigo=False):
    global BASE_WS_URL, CACHING_PB, CACHING_PB_COUNT, RDKIT_CACHE, INDIGO_CACHE, STOP_SCAN, BASE_CACHE_PATH, \
        SVG_FAILURES
    if STOP_SCAN:
        return None
    svg_path = molecule_chembl_id + '.svg' + ('?engine=indigo' if indigo else '')
    cached_file_path = os.path.join(BASE_CACHE_PATH, svg_path)
    cur_cache = INDIGO_CACHE if indigo else RDKIT_CACHE
    if molecule_chembl_id in cur_cache:
        return cur_cache[molecule_chembl_id]
    elif os.path.exists(cached_file_path):
        try:
            with open(cached_file_path, 'r', encoding='utf-8') as cached_file:
                mol_file = cached_file.read()
                if mol_file.strip() == "":
                    return None
                cur_cache[molecule_chembl_id] = mol_file
                if CACHING_PB:
                    CACHING_PB_COUNT += 1
                    CACHING_PB.update(CACHING_PB_COUNT)
                return mol_file
        except:
            traceback.print_exc()
            print('FOUND FILE AT {0} BUT WAS UNABLE TO READ IT!'.format(cached_file_path), file=sys.stderr)
    try:
        file_utf_8 = None
        req = requests.get(BASE_WS_URL+svg_path, verify=False)
        if CACHING_PB:
            CACHING_PB_COUNT += 1
            CACHING_PB.update(CACHING_PB_COUNT)
        if req.status_code == 200:
            file_utf_8 = req.content.decode("utf-8")
        else:
            framework = 'INDIGO' if indigo else 'RDKIT'
            register_fail(molecule_chembl_id, framework)
            print('SVG_FAILED: {0} {1}'.format(molecule_chembl_id, framework), file=sys.stderr)
            raise Exception('ERROR! Unexpected code {0} for {1}.'.format(req.status_code, molecule_chembl_id))
        cur_cache[molecule_chembl_id] = file_utf_8
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
        print('ERROR: unexpected error occurred when fetching {0} svg'.format(molecule_chembl_id), file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
        return None


def pre_cache_svg_files():
    global CACHING_PB, CACHING_PB_COUNT, WS_REQUEST_POOL, RDKIT_CACHE, INDIGO_CACHE, SVG_FAILURES, BASE_CACHE_PATH
    CACHING_PB = progress_bar_handler.get_new_progressbar(
      'molecule_svg_caching', max_val=es_util.get_idx_count(MOLECULE.idx_name)
    )
    CACHING_PB_COUNT = 0

    def __handle_molecule_doc(doc, *args, **kargs):
        if not STOP_SCAN:
            WS_REQUEST_POOL.submit(get_svg_by_chembl_id, doc['molecule_chembl_id'])
            WS_REQUEST_POOL.submit(get_svg_by_chembl_id, doc['molecule_chembl_id'], True)
    es_util.scan_index(
        MOLECULE.idx_name, on_doc=__handle_molecule_doc,
        query={
            '_source': 'molecule_chembl_id',
            'query': {
                'query_string': {
                    'query': '_exists_:molecule_structures'
                }
            }
        })
    WS_REQUEST_POOL.join()
    CACHING_PB.finish()
    print('RDKIT SVG data has been cached for {0} CHEMBL IDS'.format(len(RDKIT_CACHE)), file=sys.stderr)
    print('INDIGO SVG data has been cached for {0} CHEMBL IDS'.format(len(INDIGO_CACHE)), file=sys.stderr)

    indigo_fails = 0
    rdkit_fails = 0
    both_fails = 0

    for key, value in SVG_FAILURES.items():
        if len(value) > 1:
            SVG_FAILURES[key] = 'BOTH'
            both_fails += 1
        else:
            if value[0] == 'INDIGO':
                indigo_fails += 1
            else:
                rdkit_fails += 1
            SVG_FAILURES[key] = value[0]

    failures_file_path = os.path.join(BASE_CACHE_PATH, 'svg_failures.json')
    try:
        with open(failures_file_path, 'w', encoding='utf-8') as failures_file:
            json.dump(SVG_FAILURES, failures_file)
    except:
        traceback.print_exc()
        print('UNABLE TO WRITE FILE AT {0}'.format(failures_file_path), file=sys.stderr)

    print('INDIGO FAIL COUNT: {0}'.format(indigo_fails), file=sys.stderr)
    print('RDKIT FAIL COUNT: {0}'.format(rdkit_fails), file=sys.stderr)
    print('BOTH FAIL COUNT: {0}'.format(both_fails), file=sys.stderr)


if __name__ == '__main__':
    es_util.setup_connection('wp-p2m-50.ebi.ac.uk', 9200)
    pre_cache_svg_files()
