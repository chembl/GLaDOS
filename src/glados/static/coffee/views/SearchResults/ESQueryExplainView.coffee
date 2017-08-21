glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the search bar and advanced search components
  ESQueryExplainView: Backbone.View.extend

    # ------------------------------------------------------------------------------------------------------------------
    # Initialization
    # ------------------------------------------------------------------------------------------------------------------

    el: $('#es-query-explain')
    initialize: () ->
      @referencesTemplate = Handlebars.compile $("#Handlebars-query-explain-references").html()
      @atResultsPage = URLProcessor.isAtSearchResultsPage()
      @searchModel = SearchModel.getInstance()
      @searchBarView = glados.views.SearchResults.SearchBarView.getInstance()
      @query_explain_el = null
      @searchModel.bind('change queryString', @updateQueryFromModel.bind(@))
      if @atResultsPage
        $(@el).show()
        $(@searchBarView.el).hide()

    updateQueryFromModel:()->
      [queryHtml, tooltipCallbacks] = @readParsedQueryRecursive(@searchModel.get('jsonQuery'))
      $(@el).find('#query-explain-p').html(queryHtml)
      for cbI in tooltipCallbacks
        cbI()

    createTooltip: (elemId, references)->
      $hoveredElem = $('#'+elemId)
      for refI in references
        refI.joinedChemblIds = refI.chembl_ids.join(', ')
      qtipConfig =
        content:
          text: $(@referencesTemplate({
            references:references
            width: "500px"
          }))
        events:
          show: (event, api)->
            $('.collapsible').collapsible()
        show:
          solo: true
        hide:
          event: 'unfocus'
        style:
          classes:'explain-qtip qtip-light qtip-shadow'

      $hoveredElem.qtip qtipConfig

    readParsedQueryRecursive: (curParsedQuery, parentType='or', depth=0, termId='root')->
      if _.has(curParsedQuery, 'term')
        term = curParsedQuery.term
        if _.has(curParsedQuery, 'references') and curParsedQuery.references.length > 0
          termHtmlId = 'query-explain-term-'+termId
          callbackTooltip = ->
            @createTooltip(termHtmlId, curParsedQuery.references)

          return [
            '<span id="'+termHtmlId+'" class="chip-syn teal white-text">'+term+'</span>',
            [callbackTooltip.bind(@)]
          ]
        return [term, []]
  
      nextTerms = []
      curType = null
      if _.has(curParsedQuery, 'or')
        nextTerms = curParsedQuery.or
        curType = 'or'
      if _.has(curParsedQuery, 'and')
        nextTerms = curParsedQuery.and
        curType = 'and'
  
      innerTerms = []
      innerCallbacks = []
      for termI, termIndex in nextTerms
        [termStr, tooltipCallbacks]= @readParsedQueryRecursive(termI, curType, depth+1, termId+'-'+termIndex)
        innerTerms.push(termStr)
        innerCallbacks = innerCallbacks.concat(tooltipCallbacks)
      expressionStr = innerTerms.join(' ')
      if not (curType == parentType or innerTerms.length == 1)
        openParentheses = '('
        closeParentheses = ')'
        for i in [0..depth]
          openParentheses = '<big>'+openParentheses+'</big>'
          closeParentheses = '<big>'+closeParentheses+'</big>'
        expressionStr = openParentheses+expressionStr+closeParentheses
      return [expressionStr, innerCallbacks]


      

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

glados.views.SearchResults.ESQueryExplainView.getInstance = () ->
  if not glados.views.SearchResults.ESQueryExplainView.__view_instance
    glados.views.SearchResults.ESQueryExplainView.__view_instance = new glados.views.SearchResults.ESQueryExplainView
  return glados.views.SearchResults.ESQueryExplainView.__view_instance