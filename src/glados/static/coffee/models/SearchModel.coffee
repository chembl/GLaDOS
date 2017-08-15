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

  readParsedQueryRecursive: (cur_parsed_query, singular_terms, exact_terms, filter_terms)->
    # Query tree leafs
    console.log("SEARCH_DEBUG: cur_parsed_query", cur_parsed_query)
    if _.has(cur_parsed_query, 'term')
      if cur_parsed_query.include_in_query
        if cur_parsed_query.exact_match_term
          exact_terms.push(cur_parsed_query.term)
        else
          singular_terms.push(cur_parsed_query.term)
      for ref_i in cur_parsed_query.references
        exact_terms.push(ref_i.chembl_ids)
      return cur_parsed_query.term

    next_terms = []
    if _.has(cur_parsed_query, 'or')
      next_terms = cur_parsed_query.or
    if _.has(cur_parsed_query, 'and')
      next_terms = cur_parsed_query.and

    console.log("SEARCH_DEBUG: or? ", _.has(cur_parsed_query, 'or'), next_terms)
    inner_terms = []
    for term_i in next_terms
      inner_terms.push(@readParsedQueryRecursive(term_i, singular_terms, exact_terms, filter_terms))
    return '('+inner_terms.join(' ')+')'


  parseQueryString: (rawQueryString, callback)->

    done_callback = (parsed_query_json_str)->
      parsed_query = JSON.parse(parsed_query_json_str)
      chembl_ids = []
      singular_terms = []
      exact_terms = []
      filter_terms = []
      str_query = @readParsedQueryRecursive(parsed_query, singular_terms, exact_terms, filter_terms)
      exact_terms.concat(chembl_ids)
      @set('queryString', str_query)

      console.log("SEARCH_DEBUG: chembl_ids", chembl_ids)
      console.log("SEARCH_DEBUG: singular", singular_terms)
      console.log("SEARCH_DEBUG: exact", exact_terms)
      console.log("SEARCH_DEBUG: filter_terms", filter_terms)
      @set("singular_terms", singular_terms)
      @set("exact_terms", exact_terms)
      @set("filter_terms", filter_terms)
      setTimeout(callback,10)

    $.get(glados.Settings.SEARCH_RESULTS_PARSER_URL+'/'+encodeURIComponent(rawQueryString)).done(done_callback.bind(@))

  __search: ()->
    rls_dict = @getResultsListsDict()
    for resource_name, resource_es_collection of rls_dict
      # Skips the search on non selected entities
      if @selected_es_entity and @selected_es_entity != resource_name
        continue
      resource_es_collection.search(@get("singular_terms"), @get("exact_terms"), @get("filter_terms"))

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

