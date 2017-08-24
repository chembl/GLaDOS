# This model defines the simple and advanced search fields,
# and it is in charge of coordinating the query among the other models
SearchModel = Backbone.Model.extend

  # --------------------------------------------------------------------------------------------------------------------
  # Attributes
  # --------------------------------------------------------------------------------------------------------------------

  defaults:
    resultsListsDict: null
    queryString: ''
    jsonQuery: null
    autocompleteSuggestions: []

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

  requestAutocompleteSuggestions: (textQuery)->
    @set('autocompleteSuggestions', [])
    done_callback = (esData)->
      suggestions = []
      for suggI in esData.suggest.autocomplete
        for optionJ in suggI.options
          matchSection = optionJ.text.substring(suggI.offset, suggI.offset+suggI.length)
          nonMatching = optionJ.text.substring(suggI.offset+suggI.length, optionJ.text.length)
          suggestions.push({
            text: '<b>'+matchSection+'</b>'+nonMatching
            type: optionJ._id
            color: if optionJ._index == 'chembl_target' then 'lime' else 'cyan'
          })

      @set('autocompleteSuggestions', @get('autocompleteSuggestions').concat(suggestions))

    esQuery = {
      suggest:
        autocomplete:
          prefix: textQuery
          completion:
            field: "_metadata.es_completion"
    }

    deferred_t =$.post(
      glados.models.paginatedCollections.Settings.ES_BASE_URL+'/chembl_target/_search',
      JSON.stringify(esQuery)
    )
    deferred_t.done(done_callback.bind(@))
    deferred_m =$.post(
      glados.models.paginatedCollections.Settings.ES_BASE_URL+'/chembl_molecule/_search',
      JSON.stringify(esQuery)
    )
    deferred_m.done(done_callback.bind(@))

  get_es_query_for:(chembl_ids, terms, filter_terms, sub_queries, is_or=true)->
    delta = 0.3/chembl_ids.length
    query_string = terms.join(' ')
    filter_terms_joined = filter_terms.join(' AND ')
    query = {
      bool:
        must: 
          bool:
            should: []
            must: []
        filter:[]
    }
    fields_boosts_text = [
      "*.std_analyzed^1.6",
      "*.eng_analyzed^0.8",
      "*.ws_analyzed^1.4",
      "*.keyword^2",
      "*.lower_case_keyword^1.5",
      "*.alphanumeric_lowercase_keyword^1.3"
    ]
    fields_boosts_keyword = [
      "*.entity_id^2",
      "*.id_reference^1.5",
      "*.chembl_id^2",
      "*.chembl_id_reference^1.5"
    ]
    bool_query = if is_or then 'should'else 'must'
    if query_string
      query.bool.must.bool[bool_query].push(
        {
          multi_match:
            type: "phrase_prefix"
            fields: fields_boosts_text.concat fields_boosts_keyword
            query: query_string
            minimum_should_match: "100%",
        }
      )
      query.bool.must.bool[bool_query].push(
        {
          multi_match:
            type: "most_fields"
            fields: fields_boosts_text.concat fields_boosts_keyword
            query: query_string
            fuzziness: 0
            minimum_should_match: "100%"
            boost: 10

        }
      )
      query.bool.must.bool[bool_query].push(
        {
          multi_match:
            type: "best_fields"
            fields: fields_boosts_text.concat fields_boosts_keyword
            query: query_string
            fuzziness: 0
            minimum_should_match: "100%"
            boost: 2

        }
      )
      for term_i in terms
        if term_i.length >= 3
          query.bool.must.bool[bool_query].push(
            {
              multi_match:
                type: "most_fields"
                fields: fields_boosts_keyword
                query: term_i
                fuzziness: 0
                boost: 10
            }
          )
    chembl_ids_et = []
    for c_id_i, i in chembl_ids
      chembl_ids_et.push('"'+c_id_i+'"'+'^'+(1.3-i*delta))
    if chembl_ids_et.length > 0
      query.bool.must.bool[bool_query].push(
        {
          query_string:
            fields: fields_boosts_text.concat(fields_boosts_keyword)
            query: chembl_ids_et.join(' ')
            allow_leading_wildcard: false
            fuzziness: 0
            use_dis_max: false
        }
      )
    if filter_terms_joined
      query.bool.filter.push({
        query_string:
          fields: fields_boosts_text.concat fields_boosts_keyword
          query: filter_terms_joined
      })
    if sub_queries
      query.bool.must.bool[bool_query] = query.bool.must.bool[bool_query].concat(sub_queries)
    return query

  readParsedQueryRecursive: (cur_parsed_query, chembl_ids, terms, filter_terms, parent_type='or')->
    # Query tree leafs
    if _.has(cur_parsed_query, 'term')
      if cur_parsed_query.include_in_query
        if cur_parsed_query.exact_match_term
          terms.push(cur_parsed_query.term)
          filter_terms.push(cur_parsed_query.term)
        else if cur_parsed_query.filter_term
          filter_terms.push(cur_parsed_query.term)
        else
          terms.push(cur_parsed_query.term)
#          terms.push(cur_parsed_query.term.replace(
#            /([\+\-\=\&\|\!\(\)\{\}\[\]\^\"\~\:\\\/])/g, '\\$1'
#          ).replace(/[\<\>]/g, ' '))
      for ref_i in cur_parsed_query.references
        if ref_i.include_in_query
          for chembl_id_i in ref_i.chembl_ids
            if chembl_id_i.include_in_query
              chembl_ids.push(chembl_id_i.chembl_id)
      return [
        cur_parsed_query.term,
        null
      ]

    chembl_ids = []
    terms = []
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
        term_i, chembl_ids, terms, filter_terms, cur_type
      )
      inner_terms.push(term_str)
      if term_query
        inner_queries.push(term_query)
    expression_str = inner_terms.join(' ')
    if not (cur_type == parent_type or inner_terms.length == 1)
      expression_str = '('+expression_str+')'
    return [
      expression_str,
      @get_es_query_for(chembl_ids, terms, filter_terms, inner_queries, cur_type == 'or')
    ]


  parseQueryString: (rawQueryString, callback)->

    done_callback = (parsed_query_json_str)->
      parsed_query = {'or':[]}
      if parsed_query_json_str.trim()
        parsed_query = JSON.parse(parsed_query_json_str)
      chembl_ids = []
      terms = []
      filter_terms = []
      [expression_str, expression_es_query] = @readParsedQueryRecursive(
        parsed_query, chembl_ids, terms, filter_terms
      )
      if not expression_es_query
        expression_es_query = @get_es_query_for(chembl_ids, terms, filter_terms, [])
      @set('queryString', expression_str)
      @set('jsonQuery', parsed_query)
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

