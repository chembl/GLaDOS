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

  loadBase64Data: ()->
    if @egData?
      return @egData
    base64Data = 'W3sidDEiOiAiU09EYUxHIiwidDIiOiAiIWV2aWxhIGxsaXRzIG1hIEkiLCJ0MyI6ICJTT0RhTEcvbGJtZWhjL21vYy5idWh0aW'+
      'cvLzpzcHR0aCJ9LHsidDEiOiAib2lDTmVEb0ogU09EYUxHIiwidDIiOiAib2lDTmVEb0oiLCJ0MyI6ICJvemVwb2xjbi9tb2MuYnVodGlnLy8'+
      '6c3B0dGgifSx7InQxIjogIm9pQ05hVGVUIFNPRGFMRyIsInQyIjogIm9pQ05hVGVUIiwidDMiOiAiYWt0b3dvbm0vbW9jLmJ1aHRpZy8vOnNw'+
      'dHRoIn0seyJ0MSI6ICIhZU5vIFlUSEdpTSBlSFQgU09EYUxHIiwidDIiOiAiIWVObyBZVEhHaU0gZUhUIFNPRGFMRyIsInQzIjogIjJ4bWZuY'+
      'XVqL21vYy5idWh0aWcvLzpzcHR0aCJ9XQ0K'
    strData = atob(base64Data)
    @egData = JSON.parse(strData)
    for dataI in @egData
      dataI.t1 = dataI.t1.split("").reverse().join("")
      dataI.t2 = dataI.t2.split("").reverse().join("")
      dataI.t3 = dataI.t3.split("").reverse().join("")

  # --------------------------------------------------------------------------------------------------------------------
  # Functions
  # --------------------------------------------------------------------------------------------------------------------

  __requestAutocompleteSuggestions: ()->
    allSuggestions = []
    allSuggestionsScores = []
    getDoneCallBack = (es_index)->

      done_callback = (esData)->
        suggestions = []
        groupedSuggestions = {}
        for suggI in esData.suggest.autocomplete
          for optionJ in suggI.options
            suggestionI = {
              chembl_id_link: glados.models.paginatedCollections.Settings.ES_INDEX_2_GLADOS_SETTINGS[es_index]\
                .MODEL.get_colored_report_card_url(optionJ._id)
              header: false
              entityKey: glados.models.paginatedCollections.Settings.ES_INDEX_2_GLADOS_SETTINGS[es_index]\
                .KEY_NAME
              entityLabel: glados.models.paginatedCollections.Settings.ES_INDEX_2_GLADOS_SETTINGS[es_index]\
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
            if not _.has(groupedSuggestions, optionJ.text)
              groupedSuggestions[optionJ.text] = []
            groupedSuggestions[optionJ.text].push suggestionI

        sortedSuggestions = _.keys(groupedSuggestions).sort().slice 0, 5
        suggestions = []

        if sortedSuggestions.length > 0
          suggestions.push {
            color: groupedSuggestions[sortedSuggestions[0]][0].chembl_id_link.color
            header: true
            title: groupedSuggestions[sortedSuggestions[0]][0].entityLabel
            maxScore: groupedSuggestions[sortedSuggestions[0]][0].score
          }
          maxScore = 0
          for suggestionI in sortedSuggestions
            docsSuggested = groupedSuggestions[suggestionI]
            for docI in docsSuggested
              if docI.maxScore > maxScore
                maxScore = docI.maxScore
            if docsSuggested.length == 1
              suggestions.push docsSuggested[0]
            else
              suggestionI = docsSuggested[0]
              suggestionI.chembl_id_link.href = glados.routers.MainGladosRouter.getSearchURL(
                suggestionI.entityKey, suggestionI.text
              )
              suggestionI.chembl_id_link.text = 'Multiple '+suggestionI.entityLabel
              suggestions.push suggestionI

          insertAt = 0
          for scoreI in allSuggestionsScores
            if maxScore > scoreI
              break
            insertAt++
          allSuggestionsScores.splice(insertAt, 0, suggestions[0].maxScore)
          allSuggestions.splice(insertAt, 0, suggestions)
      return done_callback.bind(@)

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
            size: 50
    }
    deferreds = []
    for es_index_i_key in _.keys(glados.models.paginatedCollections.Settings.ES_INDEXES)
      es_index_i = glados.models.paginatedCollections.Settings.ES_INDEXES[es_index_i_key]
      deferred_i = $.post(
        glados.models.paginatedCollections.Settings.ES_BASE_URL + es_index_i.PATH + '/_search',
        JSON.stringify(esQuery)
      )
      deferred_i.done(getDoneCallBack(es_index_i.INDEX_NAME))
      deferreds.push(deferred_i)
    $.when.apply($, deferreds).then(then_callback.bind(@), then_callback.bind(@))

  requestAutocompleteSuggestions: (textQuery, caller)->
    @autocompleteQuery = textQuery
    @autocompleteCaller = caller
    if textQuery.startsWith('GLaDOS')
      @loadBase64Data()
      if @egData?
        for dataI in @egData
          if dataI.t1 == textQuery
            result = {
              chembl_id_link:
                color: 'pink'
                href: dataI.t3
                text: dataI.t1
              header: false
              entityLabel: dataI.t1
              score: 100
              text: dataI.t2
              highlightedText: dataI.t2
              highlights: [
                {
                  offset: 0
                  length: dataI.t2.length-1
                }
              ]
            }
            @set('autocompleteSuggestions', [result])
            return
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

    ajaxDeferred = glados.doCSRFPost glados.Settings.SEARCH_RESULTS_PARSER_ENDPOINT, {
        query_string: rawQueryString
    }
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
    if not rawQueryString?
      rawQueryString = ''
    @selected_es_entity = if _.isUndefined(selected_es_entity) then null else selected_es_entity
    ajaxDeferred = @parseQueryString(rawQueryString)
    ajaxDeferred.then(@__search.bind(@))

  resetSearchResultsListsDict: ()->
    @unset('resultsListsDict')

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

SearchModel.getInstance = () ->
  if not SearchModel.__model_instance
    SearchModel.__model_instance = new SearchModel
  return SearchModel.__model_instance

