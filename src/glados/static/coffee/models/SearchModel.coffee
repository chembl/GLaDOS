# This model defines the simple and advanced search fields,
# and it is in charge of coordinating the query among the other models
SearchModel = Backbone.Model.extend

  # --------------------------------------------------------------------------------------------------------------------
  # Attributes
  # --------------------------------------------------------------------------------------------------------------------

  defaults:
    resultsListsDict: null
    queryString: ''

  # --------------------------------------------------------------------------------------------------------------------
  # Models
  # --------------------------------------------------------------------------------------------------------------------

  # Lazily initialized CompoundResultsList
  getResultsListsDict: () ->
    if not @has('resultsListsDict')
      @set('resultsListsDict',
          glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict())
    return @get('resultsListsDict')

  # --------------------------------------------------------------------------------------------------------------------
  # Functions
  # --------------------------------------------------------------------------------------------------------------------

  get_es_query_for:(chembl_ids, singular_terms, exact_terms, filter_terms, sub_queries, is_or=true)->
    delta = 4.0/chembl_ids.length
    chembl_ids_et = []
    for c_id_i, i in chembl_ids
      chembl_ids_et.push('"'+c_id_i+'"'+'^'+(5.0-i*delta))
    joining_term = if is_or then ' ' else ' AND '
    query_string = singular_terms.concat(chembl_ids_et).concat(exact_terms).join(joining_term)
    filter_terms_joined = filter_terms.join(' AND ')
    query = {
      bool:
        should:[]
        must: []
        filter:[]
        must_not:[]
    }
    bool_query = if is_or then 'should'else 'must'
    if query_string
      query.bool[bool_query].push(
        {
          query_string:
            auto_generate_phrase_queries: true
            fields: [
                  "*.std_analyzed^1.1",
                  "*.eng_analyzed",
                  "*.ws_analyzed^1.3",
                  "*.keyword^1000",
                  "*.lower_case_keyword^750",
                  "*.alphanumeric_lowercase_keyword^500",
                  "*.entity_id^1000",
                  "*.id_reference^500",
                  "*.chembl_id^1000",
                  "*.chembl_id_reference^500"
            ]
            query: query_string
            fuzziness: 0
        }
      )
    if filter_terms_joined
      query.bool.filter.push({
        query_string:
          fields: ['*']
          query: filter_terms_joined
          fuzziness: 0
      })
    if sub_queries
      query.bool[bool_query] = query.bool[bool_query].concat(sub_queries)
    return query

  readParsedQueryRecursive: (cur_parsed_query, chembl_ids, singular_terms, exact_terms, filter_terms, parent_type='or')->
    # Query tree leafs
    if _.has(cur_parsed_query, 'term')
      if cur_parsed_query.include_in_query
        if cur_parsed_query.exact_match_term
          singular_terms.push('"'+cur_parsed_query.term+'"')
        else
          singular_terms.push(cur_parsed_query.term)
      for ref_i in cur_parsed_query.references
        if ref_i.include_in_query
          for chembl_id_i in ref_i.chembl_ids
            chembl_ids.push(chembl_id_i)
      return [
        cur_parsed_query.term,
        null
      ]

    chembl_ids = []
    singular_terms = []
    exact_terms = []
    filter_terms = []

    next_terms = []
    cur_type = null
    if _.has(cur_parsed_query, 'or')
      next_terms = cur_parsed_query.or
      cur_type = 'or'
    if _.has(cur_parsed_query, 'and')
      next_terms = cur_parsed_query.and
      cur_type = 'and'

    inner_terms = []
    inner_queries = []
    for term_i in next_terms
      [term_str, term_query] = @readParsedQueryRecursive(
        term_i, chembl_ids, singular_terms, exact_terms, filter_terms, cur_type
      )
      inner_terms.push(term_str)
      if term_query
        inner_queries.push(term_query)
    expression_str = inner_terms.join(' ')
    if not (cur_type == parent_type or inner_terms.length == 1)
      expression_str = '('+expression_str+')'
    return [
      expression_str,
      @get_es_query_for(chembl_ids, singular_terms, exact_terms, filter_terms, inner_queries, cur_type == 'or')
    ]


  parseQueryString: (rawQueryString, callback)->

    done_callback = (parsed_query_json_str)->
      parsed_query = JSON.parse(parsed_query_json_str)
      chembl_ids = []
      singular_terms = []
      exact_terms = []
      filter_terms = []
      [expression_str, expression_es_query] = @readParsedQueryRecursive(
        parsed_query, chembl_ids, singular_terms, exact_terms, filter_terms
      )
      if not expression_es_query
        expression_es_query = @get_es_query_for(chembl_ids, singular_terms, exact_terms, filter_terms, [])
      @set('queryString', expression_str)
      @set("es_list_query", expression_es_query)

      console.log("SEARCH_DEBUG: expression_es_query", expression_es_query)

      setTimeout(callback,10)

    $.get(glados.Settings.SEARCH_RESULTS_PARSER_URL+'/'+encodeURIComponent(rawQueryString)).done(done_callback.bind(@))

  __search: ()->
    rls_dict = @getResultsListsDict()
    for resource_name, resource_es_collection of rls_dict
      # Skips the search on non selected entities
      if @selected_es_entity and @selected_es_entity != resource_name
        continue
      resource_es_collection.search(@get("es_list_query"))

  # coordinates the search across the different results lists
  search: (rawQueryString, selected_es_entity) ->
    @selected_es_entity = if _.isUndefined(selected_es_entity) then null else selected_es_entity
    @parseQueryString(rawQueryString, @__search.bind(@))

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

SearchModel.getInstance = () ->
  if not SearchModel.__model_instance
    SearchModel.__model_instance = new SearchModel
  return SearchModel.__model_instance

