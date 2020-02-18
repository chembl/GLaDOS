from glados.es_models import ElasticSearchMultiSearchQuery, do_multi_search
from django.conf import settings


# ----------------------------------------------------------------------------------------------------------------------
# This class implements the functionalities to build an Elastic Search query
# ----------------------------------------------------------------------------------------------------------------------
class QueryBuilder:

    TEXT_FIELDS_BOOSTS = [
        "*.std_analyzed^1.6",
        "*.eng_analyzed^0.8",
        "*.ws_analyzed^1.4",
        "*.keyword^2",
        "*.lower_case_keyword^1.5",
        "*.alphanumeric_lowercase_keyword^1.3"
    ]

    ID_FIELDS_BOOSTS = [
        "*.entity_id^2",
        "*.id_reference^1.5",
        "*.chembl_id^2",
        "*.chembl_id_reference^1.5"
    ]

    @staticmethod
    def get_es_text_term_queries(query_string, fuzzy, minimum_should_match):
        queries = [
            {
                'multi_match': {
                    'type': 'most_fields',
                    'fields': QueryBuilder.TEXT_FIELDS_BOOSTS,
                    'query': query_string,
                    'minimum_should_match': '{0}%'.format(minimum_should_match),
                    'boost': 10,
                    'fuzziness': 'AUTO' if fuzzy else 0
                }
            },
            {
                'multi_match': {
                    'type': 'best_fields',
                    'fields': QueryBuilder.TEXT_FIELDS_BOOSTS,
                    'query': query_string,
                    'minimum_should_match': '{0}%'.format(minimum_should_match),
                    'boost': 2,
                    'fuzziness': 'AUTO' if fuzzy else 0
                }
            }
        ]
        if not'fuzzy':
            queries.append(
                {
                    'multi_match': {
                        'type': 'phrase',
                        'fields': QueryBuilder.TEXT_FIELDS_BOOSTS,
                        'query': query_string,
                        'minimum_should_match': '{0}%'.format(minimum_should_match),
                        'boost': 1.5
                    }
                }
            )
            queries.append(
                {
                    'multi_match': {
                        'type': 'phrase_prefix',
                        'fields': QueryBuilder.TEXT_FIELDS_BOOSTS,
                        'query': query_string,
                        'minimum_should_match': '{0}%'.format(minimum_should_match)
                    }
                }
            )
        return queries

    @staticmethod
    def get_es_id_term_queries(terms, fuzzy, minimum_should_match):
        queries = []
        for term_i in terms:
            if len(term_i) >= 3:
                queries.append(
                    {
                        'multi_match': {
                            'type': 'most_fields',
                            'fields': QueryBuilder.ID_FIELDS_BOOSTS,
                            'query': term_i,
                            'fuzziness': 'AUTO' if fuzzy else 0,
                            'boost': 10
                        }
                    }
                )
        return queries

    @staticmethod
    def get_es_query_for(chembl_ids, terms, filter_terms, sub_queries, fuzzy, minimum_should_match,
                         boosted_es_keys, cur_es_key, is_or=True):
        query_string = ' '.join(terms)
        filter_terms_joined = ' AND '.join(filter_terms)
        query = {
            'bool': {
                'boost': 10**9 if cur_es_key in boosted_es_keys else 1,
                'must': {
                    'bool': {
                        'should': [],
                        'must': []
                    },
                }
            }
        }
        bool_query = 'should' if is_or else 'must'
        if query_string:
            query['bool']['must']['bool'][bool_query] += QueryBuilder.get_es_text_term_queries(
                query_string, fuzzy, minimum_should_match
            )
            query['bool']['must']['bool'][bool_query] += QueryBuilder.get_es_id_term_queries(
                terms, fuzzy, minimum_should_match
            )

        if chembl_ids:
            delta = 0.3/len(chembl_ids)
            chembl_ids_et = []
            for i, c_id_i in enumerate(chembl_ids):
                chembl_ids_et.append('"{0}"^{1}'.format(c_id_i, (1.3-i*delta)))
            if len(chembl_ids_et) > 0:
                query['bool']['must']['bool'][bool_query].append(
                    {
                        'query_string': {
                            'fields': QueryBuilder.TEXT_FIELDS_BOOSTS + QueryBuilder.ID_FIELDS_BOOSTS,
                            'query': ' '.join(chembl_ids_et),
                            'allow_leading_wildcard': False,
                            'fuzziness': 0,
                            'use_dis_max': False,
                        }
                    }
                )

        if filter_terms_joined:
            query['bool']['filter'] = []
            query['bool']['filter'].append(
                {
                    'query_string': {
                        'fields': QueryBuilder.TEXT_FIELDS_BOOSTS + QueryBuilder.ID_FIELDS_BOOSTS,
                        'query': filter_terms_joined
                    }
                }
            )
        if sub_queries:
            query['bool']['must']['bool'][bool_query] = query['bool']['must']['bool'][bool_query] + sub_queries
        return query

    @staticmethod
    def build_parsed_query_recursive(cur_parsed_query, chembl_ids, terms, filter_terms, fuzzy, minimum_should_match,
                                     boosted_es_keys, cur_es_key):
        # Query tree leafs
        if 'term' in cur_parsed_query:
             # TODO
            # if cur_parsed_query['chembl_entity'] and cur_parsed_query['chembl_entity'] in 'glados.Settings.SEARCH_PATH_2_ES_KEY':
            #     boosted_es_keys.add('glados.Settings.SEARCH_PATH_2_ES_KEY[cur_parsed_query['chembl_entity']]')
            #     return None
            if cur_parsed_query['include_in_query']:
                if cur_parsed_query['exact_match_term']:
                    terms.append(cur_parsed_query['term'])
                    filter_terms.append(cur_parsed_query['term'])
                elif cur_parsed_query['filter_term']:
                    filter_terms.append(cur_parsed_query['term'])
                else:
                    terms.append(cur_parsed_query['term'])
            for ref_i in cur_parsed_query['references']:
                if ref_i['include_in_query']:
                    for chembl_id_i in ref_i['chembl_ids']:
                        if chembl_id_i['include_in_query']:
                            chembl_ids.append(chembl_id_i['chembl_id'])
            return None

        chembl_ids = []
        terms = []
        filter_terms = []
        boosted_es_keys = set()

        next_terms = []
        cur_type = None
        if 'or' in cur_parsed_query:
            next_terms = cur_parsed_query['or']
            cur_type = 'or'
        if 'and' in cur_parsed_query:
            next_terms = cur_parsed_query['and']
            cur_type = 'and'

        inner_queries = []
        for term_i in next_terms:
            term_query = QueryBuilder.build_parsed_query_recursive(
                term_i, chembl_ids, terms, filter_terms, fuzzy, minimum_should_match, boosted_es_keys, cur_es_key
            )
            if term_query:
                inner_queries.append(term_query)
        return QueryBuilder.get_es_query_for(
            chembl_ids, terms, filter_terms, inner_queries, fuzzy, minimum_should_match, boosted_es_keys, cur_es_key,
            cur_type == 'or'
        )

    @staticmethod
    def get_es_query_for_json_query(json_query, cur_es_key='', fuzzy=False, minimum_should_match=100):
        chembl_ids = []
        terms = []
        filter_terms = []
        boosted_es_keys = set()
        es_query = QueryBuilder.build_parsed_query_recursive(
            json_query, chembl_ids, terms, filter_terms, fuzzy, minimum_should_match, boosted_es_keys, cur_es_key
        )
        if not es_query:
            es_query = QueryBuilder.get_es_query_for(
                chembl_ids, terms, filter_terms, [], fuzzy, minimum_should_match, boosted_es_keys, cur_es_key
            )
        return es_query

    @staticmethod
    def get_best_es_query(json_query, indexes: list, cur_es_key=None):
        es_base_queries = []
        cur_min_should_match = 100

        while cur_min_should_match > 0:
            es_query_i = QueryBuilder.get_es_query_for_json_query(json_query, cur_es_key, False,
                                                                  cur_min_should_match)
            es_base_queries.append(es_query_i)
            cur_min_should_match -= 20

        es_base_queries.append(
            QueryBuilder.get_es_query_for_json_query(
                json_query, cur_es_key, True, 40
            )
        )
        queries = []
        for index in indexes:
            for es_query_i in es_base_queries:
                # it is necessary to request at least 1 document to get the max_score value
                queries.append(ElasticSearchMultiSearchQuery(index, {
                    'size': 1,
                    '_source': ['_id'],
                    'query': es_query_i
                }))
        results = do_multi_search(queries)['responses']
        best_queries = {}
        for i, es_index_i in enumerate(indexes):
            best_query_i = None
            best_query_i_total = 0
            best_query_i_score = 0 + (len(indexes)-i)/(10**(len(es_base_queries)+1))
            j = 0
            while best_query_i is None and j < len(es_base_queries):
                if results[i*len(es_base_queries) + j]['hits']['total'] > 0:
                    best_query_i = es_base_queries[j]
                    best_query_i_total = results[i * len(es_base_queries) + j]['hits']['total']
                    best_query_i_score += results[i * len(es_base_queries) + j]['hits']['max_score']/(10**j)
                    if es_index_i == settings.CHEMBL_ES_INDEX_PREFIX+'target':
                        best_query_i_score *= 100
                    if es_index_i == settings.CHEMBL_ES_INDEX_PREFIX+'molecule':
                        best_query_i_score *= 1000
                j += 1
            if best_query_i is None:
                best_query_i = es_base_queries[0]
            best_queries[es_index_i] = {
                'query': best_query_i,
                'total': best_query_i_total,
                'max_score': best_query_i_score
            }

        sorted_indexes_by_score = sorted(best_queries.keys(), key=lambda key: best_queries[key]['max_score'], reverse=True)
        for i, es_index_i in enumerate(indexes):
            best_queries[es_index_i]['max_score'] -= (len(indexes)-i)/(10**(len(es_base_queries)+1))
            best_queries[es_index_i]['max_score'] = round(best_queries[es_index_i]['max_score'], len(es_base_queries))

        return best_queries, sorted_indexes_by_score
