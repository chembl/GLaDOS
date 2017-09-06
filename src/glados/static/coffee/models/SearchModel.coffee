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
    debouncedAutocompleteRequest: null
    autocompleteQuery: ''

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

  __requestAutocompleteSuggestions: ()->
    allSuggestions = []
    allSuggestionsScores = []
    done_callback = (esData)->
      suggestions = []
      for suggI in esData.suggest.autocomplete
        suggestions.push()
        for optionJ in suggI.options
          suggestionI = {
            chembl_id_link: glados.models.paginatedCollections.Settings.ES_INDEX_2_GLADOS_SETTINGS[optionJ._index]\
              .MODEL.get_colored_report_card_url(optionJ._id)
            header: false
            entityLabel: glados.models.paginatedCollections.Settings.ES_INDEX_2_GLADOS_SETTINGS[optionJ._index]\
              .LABEL
            score: optionJ._score
            text: optionJ.text
            highlightedText: ''
            highlights: [
              {
                offset: suggI.offset
                length: suggI.length
              }
            ]
          }
          highlightedTextI = suggestionI.text
          for highlightJ in suggestionI.highlights
            posEnd = highlightJ.offset+highlightJ.length
            highlightedTextI = highlightedTextI.slice(0, posEnd)+'</b></big>'+highlightedTextI.slice(posEnd)
            highlightedTextI = \
              highlightedTextI.slice(0, highlightJ.offset)+'<big><b>'+highlightedTextI.slice(highlightJ.offset)
          suggestionI.highlightedText = highlightedTextI
          suggestions.push suggestionI

      if suggestions.length > 0

        suggestions.splice(0, 0, {
          color: suggestions[0].chembl_id_link.color
          header: true
          title: suggestions[0].entityLabel
          maxScore: suggestions[0].score
        })
        insertAt = 0
        for scoreI in allSuggestionsScores
          if suggestions[0].maxScore > scoreI
            break
          insertAt++
        allSuggestionsScores.splice(insertAt, 0, suggestions[0].maxScore)
        allSuggestions.splice(insertAt, 0, suggestions)

    then_callback = ()->
      concatenatedSuggestions = []
      for suggestionsI in allSuggestions
        for suggestionJ in suggestionsI
          concatenatedSuggestions.push(suggestionJ)
      @set('autocompleteSuggestions', concatenatedSuggestions)

    esQuery = {
      size: 0
      suggest:
        autocomplete:
          prefix: @autocompleteQuery
          completion:
            field: "_metadata.es_completion"
    }

    deferred_t =$.post(
      glados.models.paginatedCollections.Settings.ES_BASE_URL+'/chembl_target/_search',
      JSON.stringify(esQuery)
    )
    deferred_m =$.post(
      glados.models.paginatedCollections.Settings.ES_BASE_URL+'/chembl_molecule/_search',
      JSON.stringify(esQuery)
    )
    deferred_t.done(done_callback.bind(@))
    deferred_m.done(done_callback.bind(@))
    $.when.apply($,[deferred_m,deferred_t]).then(then_callback.bind(@))

  requestAutocompleteSuggestions: (textQuery)->
    @autocompleteQuery = textQuery
    if not @debouncedAutocompleteRequest
      @debouncedAutocompleteRequest = _.debounce(@__requestAutocompleteSuggestions.bind(@), 10)
    @debouncedAutocompleteRequest()

  readParsedQueryRecursive: (curParsedQuery, parentType='or')->
      # Query tree leafs
      if _.has(curParsedQuery, 'term')
        return curParsedQuery.term

      nextTerms = []
      curType = null
      if _.has(curParsedQuery, 'or')
        nextTerms = curParsedQuery.or
        curType = 'or'
      if _.has(curParsedQuery, 'and')
        nextTerms = curParsedQuery.and
        curType = 'and'

      innerTerms = []
      for termI in nextTerms
        termStr = @readParsedQueryRecursive termI, curType
        innerTerms.push(termStr)
      expressionStr = innerTerms.join(' ')
      if not (curType == parentType or innerTerms.length == 1)
        expressionStr = '('+expressionStr+')'
      return expressionStr
    
  parseQueryString: (rawQueryString)->

    done_callback = (parsedQueryJsonStr)->
      parsedQuery = {'or':[]}
      if parsedQueryJsonStr.trim()
        parsedQuery = JSON.parse(parsedQueryJsonStr)
      expressionStr = @readParsedQueryRecursive(parsedQuery)
      @set('queryString', expressionStr)
      @set('jsonQuery', parsedQuery)

    ajaxDeferred = $.get(glados.Settings.SEARCH_RESULTS_PARSER_URL+'/'+encodeURIComponent(rawQueryString))
    ajaxDeferred.done(done_callback.bind(@))
    return ajaxDeferred

  __search: ()->
    rls_dict = @getResultsListsDict()
    for resource_name, resource_es_collection of rls_dict
      # Skips the search on non selected entities
      if @selected_es_entity and @selected_es_entity != resource_name
        continue
      resource_es_collection.search(@get('jsonQuery'))

  # coordinates the search across the different results lists
  search: (rawQueryString, selected_es_entity) ->
    @selected_es_entity = if _.isUndefined(selected_es_entity) then null else selected_es_entity
    ajaxDeferred = @parseQueryString(rawQueryString)
    ajaxDeferred.then(@__search.bind(@))

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

SearchModel.getInstance = () ->
  if not SearchModel.__model_instance
    SearchModel.__model_instance = new SearchModel
  return SearchModel.__model_instance

