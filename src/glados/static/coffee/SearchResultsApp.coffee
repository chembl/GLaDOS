class SearchResultsApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = ->
    @searchModel = SearchModel.getInstance()
    @searchBarView = new SearchBarView()
    @initResultsListsViews()

  # --------------------------------------------------------------------------------------------------------------------
  # Views
  # --------------------------------------------------------------------------------------------------------------------

  @initResultsListsViews = () ->
    success_cb = (template) ->
      @searchResultsViewsDict = {}
      container = $('#BCK-ESResultsLists')
      srl_dict = @searchModel.getResultsListsDict()
      if container
        container_html = ''+
          '<h3>\n'+
          '  <span><i class="icon icon-functional" data-icon="b"></i>Browse Results</span>\n'+
          '</h3>\n'
        for key_i, val_i of glados.models.paginatedCollections.Settings.ES_INDEXES
          if _.has(srl_dict, key_i)
            container_html += ''+
              '<div id="BCK-'+val_i.ID_NAME+'">\n'+
              '  <h3>'+val_i.LABEL+':</h3>\n'+
              template+
              '</div>\n'
        container.html(container_html)
        for key_i, val_i of srl_dict
          rl_view_i = new glados.views.SearchResults.ESResultsListView
            collection: val_i
            el: '#BCK-'+glados.models.paginatedCollections.Settings.ES_INDEXES[key_i].ID_NAME
          @searchResultsViewsDict[key_i] = rl_view_i
        @searchBarView.search()
    success_cb = success_cb.bind(@)
    $.ajax({
        type: 'GET'
        url: glados.Settings.DEFAULT_CARD_PAGE_CONTENT_TEMPLATE_PATH
        cache: true
        success: success_cb
    })

  # --------------------------------------------------------------------------------------------------------------------
  # Graph Views
  # --------------------------------------------------------------------------------------------------------------------

  # this initialises the view that shows the compound vs target matrix view
  @initCompTargMatrixView = (topLevelElem) ->

    compTargMatrixView = new CompoundTargetMatrixView
      el: topLevelElem

    return compTargMatrixView

  # this initialises the view that shows the compound results graph view
  @initCompResultsGraphView = (topLevelElem) ->

    compResGraphView = new CompoundResultsGraphView
      el: topLevelElem

    return compResGraphView

  @initCompoundTargetMatrix = ->

    ctm = new CompoundTargetMatrix
    new CompoundTargetMatrixView
      model: ctm
      el: $('#CompTargetMatrix')
      ctm.fetch()