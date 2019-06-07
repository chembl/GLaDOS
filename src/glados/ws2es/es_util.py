import traceback
from threading import Thread
from wrapt.decorators import synchronized
from elasticsearch import Elasticsearch, Urllib3HttpConnection
from elasticsearch import helpers
import glados.ws2es.progress_bar_handler as progress_bar_handler
import glados.ws2es.signal_handler as signal_handler
from glados.ws2es.util import SummableDict
from concurrent.futures import Future
import copy
import json
import coffeescript
import sys
import time
import pprint
import math
from functools import lru_cache
from glados.ws2es.util import SharedThreadPool

__author__ = 'jfmosquera@ebi.ac.uk'


es_conn = None

########################################################################################################################


def setup_connection(host, port):
    global es_conn
    es_conn = Elasticsearch(hosts=[{'host': host, 'port': port,
                                    'transport_class': Urllib3HttpConnection, 'timeout': 60}],
                            retry_on_timeout=True)
    es_conn.cluster.health(request_timeout=60)


def ping():
    global es_conn
    return es_conn.ping()


def delete_idx(idx_name):
    global es_conn
    if es_conn.indices.exists(index=idx_name):
        es_conn.indices.delete(index=idx_name)


def get_idx_count(idx_name):
    global es_conn
    try:
        search_res = es_conn.search(index=idx_name, size=0)
        return search_res['hits']['total']
    except:
        traceback.print_exc(file=sys.stderr)
        return -1


def update_doc_type_mappings(idx_name, mappings):
    es_conn.indices.put_mapping('_doc', mappings, idx_name)


# noinspection PyBroadException
@lru_cache(maxsize=None)
def get_doc_by_id(idx_name, doc_type, doc_id, source_only=True):
    try:
        doc_data = es_conn.get(index=idx_name, doc_type=doc_type, id=doc_id)
        if source_only:
            return doc_data['_source']
        return doc_data
    except:
        return None


def update_mappings_idx(idx_name,  mappings):
    for doc_type in mappings.keys():
        es_conn.indices.put_mapping(doc_type, mappings[doc_type], idx_name)


def create_idx(idx_name, shards, replicas, analysis=None, mappings=None, logger=None):
    global es_conn
    if es_conn.indices.exists(index=idx_name):
        es_conn.indices.delete(index=idx_name, ignore=[400, 404])
    create_body = {
            'settings': {
                'index.mapping.total_fields.limit': 3000,
                'number_of_shards': shards,
                'number_of_replicas': replicas,
                'similarity': DefaultMappings.NAMES_SIMILARITY
            }
        }
    if analysis:
        create_body['settings']['analysis'] = analysis

    if mappings:
        create_body['mappings'] = mappings

    if logger:
        logger.debug("ATTEMPTING TO CREATE INDEX:{0}\nREQUEST_BODY:\n{1}"
                     .format(idx_name, json.dumps(create_body, indent=4, sort_keys=True)))
    creation_error = "UNKNOWN REASON"
    # noinspection PyBroadException
    try:
        es_conn.indices.create(index=idx_name, body=create_body)
    except:
        creation_error = traceback.format_exc()
    if not es_conn.indices.exists(index=idx_name):
        raise Exception('ERROR: Index {0} was not created!\nDue too:\n{1}'.format(idx_name, creation_error))


def get_index_mapping(es_index):
    if es_conn is None:
        print("FATAL ERROR: there is not an elastic search connection defined.", file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
        sys.exit(1)
    mappings_response = es_conn.indices.get(index=es_index)
    return list(mappings_response.values())[0]['mappings']


STOP_SCAN = False


def stop_scan(signal, frame):
    global STOP_SCAN
    STOP_SCAN = True


def scan_index(es_index, on_doc=None, query=None):
    global STOP_SCAN
    if es_conn is None:
        print("FATAL ERROR: there is not an elastic search connection defined.", file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
        sys.exit(1)
    search_res = es_conn.search(index=es_index, body=query)
    total_docs = search_res['hits']['total']
    update_every = min(math.ceil(total_docs*0.001), 1000)
    scan_query = SummableDict()
    if query:
        scan_query += query
    scanner = helpers.scan(es_conn, index=es_index, scroll='15m', query=query, size=1000)
    count = 0
    p_bar = progress_bar_handler.get_new_progressbar('{0}_es-index-scan'.format(es_index), total_docs)
    for doc_n in scanner:
        if callable(on_doc):
            should_stop = on_doc(doc_n['_source'], total_docs, count, count == 0, count == total_docs-1)
            if should_stop or STOP_SCAN:
                return
        count += 1
        if count % update_every == 0:
            p_bar.update(count)
    p_bar.finish()

# ----------------------------------------------------------------------------------------------------------------------
# BULK SUBMITTER
# ----------------------------------------------------------------------------------------------------------------------


def complete_futures_values(doc_or_list):
    if isinstance(doc_or_list, list):
        for i, item_i in enumerate(doc_or_list):
            if isinstance(item_i, dict) or isinstance(item_i, list):
                complete_futures_values(item_i)
            elif isinstance(item_i, Future):
                doc_or_list[i] = item_i.result()
    if isinstance(doc_or_list, dict):
        for key_i in doc_or_list:
            value_i = doc_or_list[key_i]
            if isinstance(value_i, dict) or isinstance(value_i, list):
                complete_futures_values(value_i)
            elif isinstance(value_i, Future):
                doc_or_list[key_i] = doc_or_list[key_i].result()


class ESBulkSubmitter(Thread):

    def __init__(self):
        super().__init__()
        self.index_actions_queue = {}
        self.index_actions_queue_stats = {}
        self.submission_pool = SharedThreadPool(max_workers=16, label='ES Bulk Submitter')
        self.error_id_counter = 0
        self.submission_pb = None
        self.submission_count = 0
        self.submission_completed_count = 0
        self.stop_submission = False
        self.submission_pb = None
        self.max_docs_per_request = 1000
        self.complete_futures = False
        signal_handler.add_termination_handler(self.stop_submitter)

    def stop_submitter(self, signal, frame):
        self.stop_submission = True

    def set_complete_futures(self, complete: bool):
        self.complete_futures = complete

    @synchronized
    def add_to_queue(self, idx_name, action):
        if idx_name not in self.index_actions_queue:
            self.index_actions_queue[idx_name] = []
            self.index_actions_queue_stats[idx_name] = {
                'submitted': 0,
                'done': 0,
                'failed': 0
            }
        self.index_actions_queue[idx_name].append(action)

    @synchronized
    def get_queue_size(self, idx_name):
        if idx_name not in self.index_actions_queue:
            return 0
        return len(self.index_actions_queue[idx_name])

    # noinspection PyBroadException
    def submit_multi_search(self, idx_name, doc_type, queries):
        try:
            task = self.submission_pool.submit(es_conn.msearch, body=queries, index=idx_name, doc_type=doc_type)
            return task.result()
        except:
            traceback.print_exc()

    @synchronized
    def get_max_queue_count(self):
        max_count = 0
        for idx_name, idx_queue in self.index_actions_queue.items():
            max_count = max(len(idx_queue), max_count)
        return max_count

    @synchronized
    def copy_queue_and_clear(self, actions_queue):
        queue_copy = copy.copy(actions_queue)
        actions_queue.clear()
        return queue_copy

    def finish_current_queues(self):
        self.check_and_submit_queues()
        while self.submission_pool.get_tasks_queue_length() > 0:
            time.sleep(0.5)

    def check_and_submit_queues(self):
        # Creates a copy of the keys to prevent concurrent edit of the dict
        idx_names_list = list(self.index_actions_queue.keys())
        for idx_name in idx_names_list:
            idx_queue = self.index_actions_queue[idx_name]
            cur_queue = self.copy_queue_and_clear(idx_queue)
            while len(cur_queue) > 0 and not self.stop_submission:
                actions_to_submit = cur_queue[:self.max_docs_per_request]
                self.submission_pool.submit(self.submit_bulk, idx_name, actions_to_submit)
                cur_queue = cur_queue[self.max_docs_per_request:]

    @synchronized
    def update_counts(self, idx_name, successful, count):
        count_path = 'done' if successful else 'failed'
        self.index_actions_queue_stats[idx_name][count_path] += count

    def join(self, timeout=None):
        self.check_and_submit_queues()
        self.submission_pool.join()
        self.stop_submission = True
        super().join(timeout)

    def run(self):
        self.submission_pb = progress_bar_handler.get_new_progressbar('ES-bulk-submitter', 1)
        self.submission_pool.start()
        cur_low_counts = 0
        while not self.stop_submission:
            max_count = self.get_max_queue_count()
            if max_count >= self.max_docs_per_request * 5 or (max_count > 0 and cur_low_counts > 10):
                cur_low_counts = 0
                self.check_and_submit_queues()
            else:
                if max_count > 0:
                    cur_low_counts += 1
                time.sleep(1)
                sys.stderr.flush()

    @synchronized
    def get_next_error_id(self):
        self.error_id_counter += 1
        return self.error_id_counter

    @synchronized
    def update_pb(self, start, success=False):
        if start:
            self.submission_count += 1
            self.submission_pb.start(max_value=self.submission_count)
            self.submission_pb.update(self.submission_completed_count)
        else:
            if success:
                self.submission_completed_count += 1
            self.submission_pb.update(self.submission_completed_count)

    # noinspection PyBroadException
    def submit_bulk(self, idx_name, actions):
        self.update_pb(True)
        if self.complete_futures:
            complete_futures_values(actions)
        error_id = None
        success = False
        for try_i in range(4):
            if self.stop_submission:
                return
            try:
                helpers.bulk(client=es_conn, actions=actions)
                success = True
                break
            except:
                if error_id is None:
                    error_id = self.get_next_error_id()
                print("ERROR ON SUBMISSION TO ELASTIC!! TRY: {0} ERROR_ID: {1} AT: {2}"
                      .format(try_i, error_id, time.strftime("%a, %d %b %Y %H:%M:%S +0000")),
                      file=sys.stderr)
                with open('./ERROR_{0}_try_{1}.trace'.format(error_id, try_i), 'w') as error_file:
                    error_file.write(traceback.format_exc()+'\n')
                with open('./ERROR_{0}_try_{1}_request.py'.format(error_id, try_i), 'w') as error_req_file:
                    error_req_file.write('request = \\\n')
                    error_req_file.write(pprint.pformat(actions))

                sys.stderr.flush()
                # Retries after giving the server a small break
                time.sleep(3**(try_i+1))
        self.update_counts(idx_name, success, len(actions))
        self.update_pb(False, success)


bulk_submitter = ESBulkSubmitter()
# bulk_submitter.start()


def index_doc_bulk(idx_name, doc_id, dict_doc, logger=None):
    action = {
        '_index': idx_name,
        '_id': doc_id,
        '_source': json.dumps(dict_doc),
        '_type': '_doc'
    }
    bulk_submitter.add_to_queue(idx_name, action)


def update_doc_bulk(idx_name, doc_id, script=None, doc=None):
    action = {
        '_op_type': 'update',
        '_index': idx_name,
        '_id': doc_id,
        '_type': '_doc'
    }
    if script is not None:
        action['script'] = script
    if doc is not None:
        action['doc'] = doc
    bulk_submitter.add_to_queue(idx_name, action)


def index_doc(idx_name, doc_type, doc_id, dict_doc):
    global es_conn
    es_conn.index(idx_name, doc_type, dict_doc, doc_id)


def run_coffee_query(coffee_query_file, index, doc_type, replacements_dict=None):
    """

    :param coffee_query_file: WARNING: this file must use JSON format
    e.g. {a:0,b:"text"} will not work, but {"a":0,"b":"text"} will.
    :param index:
    :param doc_type:
    :param replacements_dict:
    :return:
    """
    global es_conn
    coffee_query_file = coffee_query_file
    compiled = coffeescript.compile_file(coffee_query_file, bare=True)
    if replacements_dict:
        for key, val in replacements_dict.items():
            compiled = compiled.replace(key, val)
    # removes unnecessary prefix and suffix added by the compiler ['(', ');']
    compiled = compiled[1:-3]
    result = es_conn.search(index=index, doc_type=doc_type, body=compiled)

    results = []
    for hits_idx, hit_i in enumerate(result['hits']['hits']):
        results.append(hit_i['_source'])
    return results

shards_guide = {
        0: 1,
        10**5: 2,
        10**6: 3,
        10**7: 5,
        10**8: 8,
        10**9: 13,
        10**10: 21
    }


def num_shards_by_num_rows(n_rows):
    cur_i = 0
    guides = sorted(shards_guide.keys())
    while cur_i < len(guides) and n_rows >= guides[cur_i]:
        cur_i += 1
    return shards_guide[guides[cur_i-1]]


def remove_es_mapping_properties_level(mapping_dict: dict={}):
    return_dict = {}
    for key, value in mapping_dict.items():
        if key == 'properties' and isinstance(value, dict):
            for inner_key, inner_value in value.items():
                if isinstance(inner_value, dict):
                    if 'properties' not in inner_value.keys():
                        inner_value['es_mapping_leaf'] = True
                        return_dict[inner_key] = inner_value
                    else:
                        return_dict[inner_key] = remove_es_mapping_properties_level(inner_value)
                else:
                    return_dict[key] = inner_value
        elif isinstance(value, dict):
            if 'properties' not in value.keys():
                value['es_mapping_leaf'] = True
                return_dict[key] = value
            else:
                return_dict[key] = remove_es_mapping_properties_level(value)
        elif value:
            return_dict[key] = value
    return return_dict


def simplify_single_mapping(single_mapping):
    mapping_type = single_mapping['type']
    indexed = single_mapping.get('index', True)
    return {
        'type': DefaultMappings.SIMPLE_MAPPINGS_REVERSE[mapping_type],
        'aggregatable': indexed and mapping_type in DefaultMappings.AGGREGATABLE_TYPES
    }


def _recursive_simplify_es_properties(cur_dict: dict, cur_prefix: str):
    simple_props = SummableDict()
    for key, value in cur_dict.items():
        next_prefix = '{0}.{1}'.format(cur_prefix, key) if cur_prefix else key
        if isinstance(value, dict):
            if 'es_mapping_leaf' in value.keys():
                simple_props[next_prefix] = simplify_single_mapping(value)
            else:
                simple_props += _recursive_simplify_es_properties(value, next_prefix)
        elif value:
            simple_props[next_prefix] = value
    return simple_props


def simplify_es_properties(mappings_dict: dict):
    mappings_dict_no_props = remove_es_mapping_properties_level(mappings_dict)
    return _recursive_simplify_es_properties(mappings_dict_no_props, '')


class DefaultMappings(object):
    # Similarity
    NAMES_SIMILARITY = {
        'ngram_names_similarity': {
            'type': 'LMJelinekMercer',
            'lambda': 0.1
        }
    }

    # common custom analysis
    COMMON_TOKENIZERS = SummableDict(
        name_ngram_tokenizer=
        {
            'type': 'ngram',
            'min_gram': 3,
            'max_gram': 8,
            'token_chars': [
              'letter',
              'digit'
            ]
        },
        b_seq_ngram_tokenizer=
        {
            'type': 'ngram',
            'min_gram': 1,
            'max_gram': 3,
            'token_chars': [
              'letter',
              'digit'
            ]
        }
    )

    COMMON_CHAR_FILTERS = SummableDict(
        alphanumeric_and_space_char_filter=
        {
            'type': 'pattern_replace',
            'pattern': '[^a-zA-Z0-9\s]',
            'replacement': ''
        },
        vitamin_char_filter=
        {
            'type': 'pattern_replace',
            'pattern': r'(?:\b(?:vitamin|vit))\s+([a-z])(?:\s*(\d+))?',
            'flags': 'CASE_INSENSITIVE',
            'replacement': 'vitamin_$1$2'
        }
    )

    COMMON_FILTERS = SummableDict(
        greek_synonym_filter={
            'type': 'synonym',
            'synonyms_path': './synonyms/greek_letters_synonyms.txt'
        },
        english_stop={
          'type':       'stop',
          'stopwords':  '_english_'
        },
        english_keywords={
          'type':       'keyword_marker',
          'keywords':   ['example']
        },
        english_stemmer={
          'type':       'stemmer',
          'language':   'english'
        },
        english_possessive_stemmer={
          'type':       'stemmer',
          'language':   'possessive_english'
        }
    )

    COMMON_ANALYZERS = SummableDict(
                    greek_syn_std_analyzer={
                        'type': 'custom',
                        'tokenizer': 'standard',
                        'filter': ['standard', 'greek_synonym_filter', 'lowercase'],
                        'char_filter': 'vitamin_char_filter'
                    }, greek_syn_eng_analyzer={
                        'type': 'custom',
                        'tokenizer': 'standard',
                        'filter': ['standard', 'greek_synonym_filter',
                                   # English analyzer based on:
                                   # https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-lang-analyzer.html#english-analyzer
                                   'english_possessive_stemmer',
                                   'lowercase',
                                   'english_stop',
                                   'english_keywords',
                                   'english_stemmer'],
                        'char_filter': 'vitamin_char_filter'
                    }, lowercase_keyword={
                        'type': 'custom',
                        'tokenizer': 'keyword',
                        'filter': 'lowercase'
                    }, alphanumeric_lowercase_keyword={
                        'type': 'custom',
                        'tokenizer': 'keyword',
                        'filter': 'lowercase',
                        'char_filter': 'alphanumeric_and_space_char_filter'
                    }, lowercase_ngrams={
                        'type': 'custom',
                        'tokenizer': 'name_ngram_tokenizer',
                        'filter': 'lowercase',
                        'char_filter': 'alphanumeric_and_space_char_filter'
                    },
                    whitespace_alphanumeric_lowercase_std_analyzer={
                        'type': 'custom',
                        'tokenizer': 'whitespace',
                        'filter': ['standard', 'lowercase'],
                        'char_filter': ['vitamin_char_filter', 'alphanumeric_and_space_char_filter']
                    })

    COMMON_ANALYSIS = SummableDict(
        char_filter=COMMON_CHAR_FILTERS,
        tokenizer=COMMON_TOKENIZERS,
        analyzer=COMMON_ANALYZERS,
        filter=COMMON_FILTERS
    )

    # Indexing mappings
    __NO_INDEX = SummableDict(index=False)
    __DO_INDEX = SummableDict(index=True)
    __IGNORE_ABOVE = SummableDict(ignore_above=250)

    # Basic Types
    __TEXT_TYPE_NO_OFFSETS = SummableDict(type='text')
    __TEXT_TYPE = SummableDict(type='text', term_vector='with_positions_offsets')
    __KEYWORD_TYPE = SummableDict(type='keyword')
    COMPLETION_TYPE = SummableDict(type='completion', analyzer='greek_syn_std_analyzer')
    BYTE = SummableDict(type='byte')
    SHORT = SummableDict(type='short')
    INTEGER = SummableDict(type='integer')
    LONG = SummableDict(type='long')
    FLOAT = SummableDict(type='float')
    DOUBLE = SummableDict(type='double')
    BOOLEAN = SummableDict(type='boolean')
    DATE_Y_M_D = SummableDict(type='date', format='yyyy-MM-dd')

    # Text Field Types

    __KEYWORD_FIELD = SummableDict(fields={
        'keyword': __KEYWORD_TYPE + __DO_INDEX
        })

    __ALPHANUMERIC_LOWERCASE_KEYWORD = SummableDict(fields={
        'alphanumeric_lowercase_keyword':
            __TEXT_TYPE + __DO_INDEX + {'analyzer': 'alphanumeric_lowercase_keyword'}
        })

    __LOWER_CASE_KEYWORD_FIELD = SummableDict(fields={
        'lower_case_keyword': __TEXT_TYPE + __DO_INDEX + {'analyzer': 'lowercase_keyword'}
        })

    __ID_FIELD = SummableDict(fields={
        'entity_id': __KEYWORD_FIELD['fields']['keyword']
        })

    __ID_REF_FIELD = SummableDict(fields={
        'id_reference': __KEYWORD_FIELD['fields']['keyword']
        })

    __CHEMBL_ID_FIELD = SummableDict(fields={
        'chembl_id': __KEYWORD_FIELD['fields']['keyword']
        })

    __CHEMBL_ID_REF_FIELD = SummableDict(fields={
        'chembl_id_reference': __CHEMBL_ID_FIELD['fields']['chembl_id']
        })

    __STD_ANALYZED_FIELD = SummableDict(fields={
        'std_analyzed': __TEXT_TYPE + __DO_INDEX + {'analyzer': 'greek_syn_std_analyzer'}
        })
    __ENG_ANALYZED_FIELD = SummableDict(fields={
        'eng_analyzed': __TEXT_TYPE + __DO_INDEX + {'analyzer': 'greek_syn_eng_analyzer'}
        })
    __WS_ANALYZED_FIELD = SummableDict(fields={
        'ws_analyzed': __TEXT_TYPE + __DO_INDEX + {'analyzer': 'whitespace_alphanumeric_lowercase_std_analyzer'}
        })
    __ALT_NAME_ANALYZED_FIELD = SummableDict(fields={
        'alt_name_analyzed': __TEXT_TYPE + __DO_INDEX + {
            'analyzer': 'lowercase_ngrams',
            'similarity': 'ngram_names_similarity'
        }
        })
    __PREF_NAME_ANALYZED_FIELD = SummableDict(fields={
        'pref_name_analyzed': __ALT_NAME_ANALYZED_FIELD['fields']['alt_name_analyzed']
        })

    __TITLE_ANALYZED_FIELD = SummableDict(fields={
        'title_analyzed': __ALT_NAME_ANALYZED_FIELD['fields']['alt_name_analyzed']
        })

    # Properties MAPPINGS

    NO_INDEX_KEYWORD = __NO_INDEX + __KEYWORD_TYPE
    NO_INDEX_TEXT_NO_OFFSETS = __NO_INDEX + __TEXT_TYPE_NO_OFFSETS

    # KEYWORD FIELDS indexation for the field itself (Aggregatable fields)

    KEYWORD = __DO_INDEX + __KEYWORD_TYPE + __KEYWORD_FIELD + __ALPHANUMERIC_LOWERCASE_KEYWORD

    LOWER_CASE_KEYWORD = __DO_INDEX + __KEYWORD_TYPE + __LOWER_CASE_KEYWORD_FIELD + __ALPHANUMERIC_LOWERCASE_KEYWORD

    ID = __DO_INDEX + __KEYWORD_TYPE + __ID_FIELD + __ALPHANUMERIC_LOWERCASE_KEYWORD

    ID_REF = __DO_INDEX + __KEYWORD_TYPE + __ID_REF_FIELD + __ALPHANUMERIC_LOWERCASE_KEYWORD

    CHEMBL_ID = __DO_INDEX + __KEYWORD_TYPE + __CHEMBL_ID_FIELD + __ALPHANUMERIC_LOWERCASE_KEYWORD

    CHEMBL_ID_REF = __DO_INDEX + __KEYWORD_TYPE + __CHEMBL_ID_REF_FIELD + __ALPHANUMERIC_LOWERCASE_KEYWORD

    CHEMBL_ID_REF_AS_WS = __DO_INDEX + __TEXT_TYPE_NO_OFFSETS + __WS_ANALYZED_FIELD

    # TEXT FIELDS no indexation for the field itself (Non Aggregatable)

    TEXT_STD = __DO_INDEX + __KEYWORD_TYPE + __IGNORE_ABOVE + __STD_ANALYZED_FIELD + __ENG_ANALYZED_FIELD + \
        __WS_ANALYZED_FIELD

    PREF_NAME = __DO_INDEX + __KEYWORD_TYPE + __IGNORE_ABOVE + __STD_ANALYZED_FIELD + __ENG_ANALYZED_FIELD + \
        __WS_ANALYZED_FIELD + __PREF_NAME_ANALYZED_FIELD

    ALT_NAME = __DO_INDEX + __KEYWORD_TYPE + __IGNORE_ABOVE + __STD_ANALYZED_FIELD + __ENG_ANALYZED_FIELD + \
        __WS_ANALYZED_FIELD + __ALT_NAME_ANALYZED_FIELD

    TITLE = __DO_INDEX + __KEYWORD_TYPE + __IGNORE_ABOVE + __STD_ANALYZED_FIELD + __ENG_ANALYZED_FIELD + \
        __WS_ANALYZED_FIELD + __TITLE_ANALYZED_FIELD

    NUMERIC_MAPPINGS = [BYTE, SHORT, INTEGER, LONG, FLOAT, DOUBLE]
    INTEGER_NUMERIC_MAPPINGS = [BYTE, SHORT, INTEGER, LONG]
    AGGREGATABLE_MAPPINGS = [
        BOOLEAN,
        # Numeric Types
        BYTE, SHORT, INTEGER, LONG, FLOAT, DOUBLE,
        # Text Types
        KEYWORD, LOWER_CASE_KEYWORD, ID_REF, CHEMBL_ID_REF, ID, CHEMBL_ID
    ]

    NUMERIC_TYPES = {desc_i['type'] for desc_i in NUMERIC_MAPPINGS}
    INTEGER_NUMERIC_TYPES = {desc_i['type'] for desc_i in INTEGER_NUMERIC_MAPPINGS}
    AGGREGATABLE_TYPES = {desc_i['type'] for desc_i in AGGREGATABLE_MAPPINGS}

    SIMPLE_MAPPINGS = {
        'string': {__KEYWORD_TYPE['type'], __TEXT_TYPE['type']},
        'string-es-interal': {COMPLETION_TYPE['type'], },
        'double': {FLOAT['type'], DOUBLE['type']},
        'integer': INTEGER_NUMERIC_TYPES,
        'boolean': {BOOLEAN['type']},
        'date': {DATE_Y_M_D['type'], }
    }
    SIMPLE_MAPPINGS_REVERSE = {}
    for s_type, types in SIMPLE_MAPPINGS.items():
        for type in types:
            SIMPLE_MAPPINGS_REVERSE[type] = s_type

    # Enable/Disable
    ENABLE = SummableDict(enabled=True)
    DISABLE = SummableDict(enabled=False)
