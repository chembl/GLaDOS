import glados.ws2es.es_util as es_util
import sys
import logging
import time
import traceback
import pprint
import coffeescript
import os

__author__ = 'jfmosquera@ebi.ac.uk'

logging_level = logging.INFO

logging.basicConfig(level=logging_level)
log = logging.getLogger()
log.setLevel(logging_level)

doc_id_seq = 0
test_idx_name = 'testing_idx'
custom_analysis = es_util.DefaultMappings.COMMON_ANALYSIS
test_doc_name = 'test_doc'
test_str_std_name = 'test_field_str_std'
custom_mappings = {
    test_doc_name: {
        '_all': es_util.DefaultMappings.DISABLE,
        'properties': {
            test_str_std_name: es_util.DefaultMappings.TEXT_STD,
        }
    }
}

CUR_SCRIPT_PATH = os.path.abspath(os.path.dirname(__file__))


def create_test_doc(str_field):
    global doc_id_seq, test_idx_name, test_doc_name, test_str_std_name
    new_doc = {
        test_str_std_name: str_field
    }
    es_util.index_doc(test_idx_name, test_doc_name, doc_id_seq, new_doc)
    doc_id_seq += 1


def filter_dict(dict_to_filter, keys_to_show):
    return {key_i: dict_to_filter[key_i] for key_i in keys_to_show}


def run_coffee_query(coffee_query_file, index, doc_type, replacements_dict=None, show_only=None):
    """

    :param coffee_query_file: WARNING: this file must use JSON format
    e.g. {a:0,b:"text"} will not work, but {"a":0,"b":"text"}.
    :param index:
    :param doc_type:
    :param replacements_dict:
    :return:
    """
    global CUR_SCRIPT_PATH
    if not os.path.isabs(coffee_query_file):
        coffee_query_file = os.path.join(CUR_SCRIPT_PATH, coffee_query_file)
    compiled = coffeescript.compile_file(coffee_query_file, bare=True)
    if replacements_dict:
        for key, val in replacements_dict.items():
            compiled = compiled.replace(key, val)
    # removes unnecessary prefix and suffix added by the compiler ['(', ');']
    compiled = compiled[1:-3]
    # log.info("QUERY_JSON:\n{0}".format(compiled))
    result = es_util.es_conn.search(index=index, doc_type=doc_type, body=compiled)

    for hits_idx, hit_i in enumerate(result['hits']['hits']):
        log.info("QUERY_RESULT: SCORE:{0}".format(hit_i['_score']))
        source = hit_i['_source']
        if type(show_only) == list:
            source = filter_dict(source, show_only)
        log.info("SOURCE_{0}:\n{1}".format(hits_idx, pprint.pformat(source)))


def analyze(text, analyzer, tokens_only=True):
    global test_idx_name
    analyzed = es_util.es_conn.indices.analyze(index=test_idx_name, body=text, analyzer=analyzer)
    log.info("ANALYSIS FOR: '{0}' USING '{1}'".format(text, analyzer))
    res_tokens = []
    if tokens_only:
        for token_desc in analyzed['tokens']:
            log.info(token_desc['token'])
            res_tokens.append(token_desc['token'])
    else:
        log.info(pprint.pformat(analyzed, indent=2))
    return res_tokens


def run_analysers():
    global test_idx_name, test_doc_name, test_str_std_name, custom_mappings, custom_analysis
    try:
        es_util.create_idx(test_idx_name, 1, 1, mappings=custom_mappings,
                           analysis=custom_analysis, logger=logging.getLogger())
        time.sleep(1)
        analyze('CHEMBL_25', 'lowercase_keyword')
        analyze('CHEMBL_25', 'lowercase_alphanumeric_keyword')
        analyze('CHEMBL_25', 'lowercase_ngrams')
        analyze('ASPIRIN', 'lowercase_ngrams')
        analyze('SILDENAFIL CITRATE', 'lowercase_ngrams')
        analyze('Acetylsalicylic Acid', 'standard')
        analyze('Acetyl salicylic Acid', 'standard')
        analyze('6-Octylsalicylic Acid', 'lowercase_ngrams')
        create_test_doc('Acetylsalicylic Acid')
        create_test_doc('6-Octylsalicylic Acid')
        create_test_doc('ACETYLSALICYLIC-LYSINE')
        time.sleep(3)
        run_coffee_query("./es_query_test.coffee", test_idx_name, test_doc_name,
                         replacements_dict={
                             "<SEARCH_STRING>": "Acetylsalicylic Acid"
                         },
                         show_only=[
                             test_str_std_name
                         ]
                         )

    except Exception as e:
        traceback.print_exc()
    finally:
        es_util.delete_idx(test_idx_name)


def run_coffee_queries():
    # run_analysers()
    run_coffee_query("./es_query_test.coffee", "chembl_molecule", "molecule",
                     replacements_dict={
                         "<SEARCH_STRING>": "Acetyl salicylic Acid"
                     },
                     show_only=[
                         "pref_name",
                         "molecule_synonyms"
                     ]
                     )
    run_coffee_query("./es_query_test.coffee", "chembl_molecule", "molecule",
                     replacements_dict={
                         "<SEARCH_STRING>": "viagra"
                     },
                     show_only=[
                         "pref_name",
                         "molecule_synonyms"
                     ]
                     )
    # run_coffee_query("./es_query_string_test.coffee", "chembl_molecule", "molecule",
    #                  show_only=[
    #                      "pref_name",
    #                      "molecule_synonyms",
    #                      # "molecule_properties"
    #                  ]
    #                  )


def main():
    es_util.setup_connection(host='ves-hx-5e.ebi.ac.uk', port=9200)
    if not es_util.ping():
        logging.error("ERROR: Can not establish connection with the elastic search server.")
        sys.exit(1)
    run_coffee_queries()

########################################################################################################################

if __name__ == "__main__":
    main()

########################################################################################################################
