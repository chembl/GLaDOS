glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the search bar and advanced search components
  ESQueryExplainView: Backbone.View.extend

    # ------------------------------------------------------------------------------------------------------------------
    # Initialization
    # ------------------------------------------------------------------------------------------------------------------

    initialize: ->
      console.log 'INIT QUERY EXPLAIN!!'
      @referencesTemplate = Handlebars.compile $("#Handlebars-query-explain-references").html()

      console.log '$(@el): ', $(@el)
      @searchModel = SearchModel.getInstance()
      @searchModel.on('change:jsonQuery', @updateQueryFromModel.bind(@))
      if @searchModel.get('queryString')
        @updateQueryFromModel()
      @query_explain_el = null
      @tooltipCallbacks = []

      $(@el).show()

    updateQueryFromModel:()->
      [queryHtml, @tooltipCallbacks] = @buildParsedQueryRecursive(@searchModel.get('jsonQuery'))
      $(@el).find('.query-explain-p').html(queryHtml)
      for cbI in @tooltipCallbacks
        cbI()

    createTooltip: (elemId, references)->
      $hoveredElem = $(@el).find('.'+elemId)
      tooltipId = elemId+'-tooltip'
      tooltipHtml = $(@referencesTemplate({
        references:references
        width: "500px"
        tooltipId: tooltipId
      }))
      $tooltipContentElem = null

      adjustTooltipPosition = (timeout=0)->
        setTimeout(
          ()->
            position = glados.Utils.Tooltips.getQltipSafePostion $hoveredElem, $tooltipContentElem
            $hoveredElem.qtip 'option', 'position.my', position.my
            $hoveredElem.qtip 'option', 'position.at', position.at
          , timeout
        )

      showHandler = ()->
        if not $tooltipContentElem
          $tooltipContentElem = $('#'+tooltipId)
          $tooltipContentElem.find('.collapsible').collapsible {
            onOpen: adjustTooltipPosition.bind(@, 500)
            onClose: adjustTooltipPosition.bind(@, 500)
          }
        adjustTooltipPosition()

      qtipConfig =
        content:
          text: tooltipHtml
        events:
          show: showHandler.bind(@)
        hide:
          event: 'unfocus'
        show:
          solo: true
        style:
          classes:'simple-qtip qtip-light qtip-shadow'

      $hoveredElem.qtip qtipConfig

    buildParsedQueryRecursive: (curParsedQuery, parentType='or', depth=0, termId='root')->
      if _.has(curParsedQuery, 'term')
        term = curParsedQuery.term
        if curParsedQuery.chembl_entity or (_.has(curParsedQuery, 'references') and curParsedQuery.references.length > 0)
          termHtmlId = 'query-explain-term-'+termId
          callbackTooltip = ->
            @createTooltip(termHtmlId, curParsedQuery.references)
          color = 'lime'
          if curParsedQuery.chembl_entity and _.has(glados.Settings.SEARCH_PATH_2_ES_KEY, curParsedQuery.chembl_entity)
            esKey = glados.Settings.SEARCH_PATH_2_ES_KEY[curParsedQuery.chembl_entity]
            color = glados.models.paginatedCollections.Settings.ES_INDEXES[esKey].MODEL.color
          return [
            '<span class="chip-syn '+color+' darken-2 white-text hoverable '+termHtmlId+'">'+term+'</span>',
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
        [termStr, tooltipCallbacks]= @buildParsedQueryRecursive(termI, curType, depth+1, termId+'-'+termIndex)
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

    # ------------------------------------------------------------------------------------------------------------------
    # Events Handling
    # ------------------------------------------------------------------------------------------------------------------

    events:
      'click .es-query-explain-show' : 'showExplainDiv'
      'click .es-query-explain-close' : 'closeExplainDiv'

    showExplainDiv: ()->
      $(@el).find('.es-query-explain').slideDown()
      $(@el).find('.es-query-explain-header').hide(400)

    closeExplainDiv: ()->
      $(@el).find('.es-query-explain').slideUp()
      $(@el).find('.es-query-explain-header').show(400)
