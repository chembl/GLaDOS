glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the search bar and advanced search components
  SearchBarView: Backbone.View.extend

    # --------------------------------------------------------------------------------------------------------------------
    # Initialization
    # --------------------------------------------------------------------------------------------------------------------

    el: $('#BCK-SRB-wrapper')
    initialize: () ->
      @showAdvanced = URLProcessor.isAtAdvancedSearchResultsPage()
      @atResultsPage = URLProcessor.isAtSearchResultsPage()
      @searchModel = SearchModel.getInstance()
      # Don't instantiate the ResultsLists if it is not necessary
      if @atResultsPage
        @initResultsListsViews()
      @render()
      @searchModel.bind('change queryString', @updateSearchBarFromModel.bind(@))
      # Handles the popstate event to reload a search
      window.onpopstate = @searchFromURL.bind(@)
      @searchFromURL()

    searchFromURL: ()->
      if @atResultsPage
          urlQueryString = decodeURI(URLProcessor.getSearchQueryString())
          if urlQueryString and urlQueryString != @lastURLQuery
            $('#search_bar').val(urlQueryString)
            @searchModel.search(urlQueryString)
            @lastURLQuery = urlQueryString

    # --------------------------------------------------------------------------------------------------------------------
    # Views
    # --------------------------------------------------------------------------------------------------------------------

    reorderCollections: ()->
      sorted_scores = []
      insert_score_in_order = (_score)->
        inserted = false
        for score_i, i in sorted_scores
          if score_i < _score
            sorted_scores.splice(i,0,_score)
            inserted = true
            break
        if not inserted
          sorted_scores.push(_score)
      keys_by_score = {}
      for key_i, val_i of glados.models.paginatedCollections.Settings.ES_INDEXES
        srl_dict = @searchModel.getResultsListsDict()
        if _.has(srl_dict, key_i)
          score_i = srl_dict[key_i].getMeta("max_score")
          total_records = srl_dict[key_i].getMeta("total_records")
          if not score_i
            score_i = 0
          if not total_records
            total_records = 0
          # Boost compounds and targets to the top!
          boost = 1
          if val_i.KEY_NAME == glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
            boost = 100
          else if val_i.KEY_NAME == glados.models.paginatedCollections.Settings.ES_INDEXES.TARGET.KEY_NAME
            boost = 50
          score_i *= boost

          if not _.has(keys_by_score,score_i)
            keys_by_score[score_i] = []
          keys_by_score[score_i].push(key_i)
          insert_score_in_order(score_i)
      console.log(sorted_scores,keys_by_score)
      lists_container = $('#BCK-ESResultsLists-lists')
      for score_i in sorted_scores
        for key_i in keys_by_score[score_i]
          div_key_i = $('#BCK-'+glados.models.paginatedCollections.Settings.ES_INDEXES[key_i].ID_NAME)
          lists_container.append(div_key_i)

    initResultsListsViews: () ->
      success_cb = (template) ->
        @searchResultsViewsDict = {}
        @container = $('#BCK-ESResultsLists')
        srl_dict = @searchModel.getResultsListsDict()
        if @container
          container_html = ''+
            '<div id="BCK-ESResultsLists-header">'+
            '  <h3>\n'+
            '    <span><i class="icon icon-functional" data-icon="b"></i>Browse Results</span>\n'+
            '  </h3>'+
            '</div>\n'
          container_html += '<div id="BCK-ESResultsLists-lists">'
          for key_i, val_i of glados.models.paginatedCollections.Settings.ES_INDEXES
            if _.has(srl_dict, key_i)
              # event register for score update
              srl_dict[key_i].on('score_update',@reorderCollections.bind(@))
              container_html += ''+
                '<div id="BCK-'+val_i.ID_NAME+'">\n'+
                '  <h3>'+val_i.LABEL+':</h3>\n'+
                template+
                '</div>\n'
          container_html += '</div>'
          @container.html(container_html)
          for key_i, val_i of srl_dict
            rl_view_i = new glados.views.SearchResults.ESResultsListView
              collection: val_i
              el: '#BCK-'+glados.models.paginatedCollections.Settings.ES_INDEXES[key_i].ID_NAME
            @searchResultsViewsDict[key_i] = rl_view_i
      success_cb = success_cb.bind(@)
      $.ajax({
          type: 'GET'
          url: glados.Settings.DEFAULT_CARD_PAGE_CONTENT_TEMPLATE_PATH
          cache: true
          success: success_cb
      })

    # --------------------------------------------------------------------------------------------------------------------
    # Events Handling
    # --------------------------------------------------------------------------------------------------------------------

    events:
      'click .example_link' : 'searchExampleLink'
      'click #submit_search' : 'search'
      'click #search-opts' : 'searchAdvanced'
      'keyup #search_bar' : 'searchBarKeyUp',
      'change #search_bar' : 'searchBarChange'

    updateSearchBarFromModel: (e) ->
      $('#search_bar').val(@searchModel.get('queryString'))

    searchBarKeyUp: (e) ->
      if e.which == 13
        @search()

    searchBarChange: (e) ->
      console.log($(e.currentTarget).val())

    searchExampleLink: (e) ->
      exampleString = $(e.currentTarget).html()
      $('#search_bar').val(exampleString)
      @search()

    # --------------------------------------------------------------------------------------------------------------------
    # Additional Functionalities
    # --------------------------------------------------------------------------------------------------------------------

    search: () ->
      searchBarQueryString = $('#search_bar').val()
      search_url_for_query = glados.Settings.SEARCH_RESULTS_PAGE+"/"+encodeURI(searchBarQueryString)
      # Updates the navigation URL
      window.history.pushState({}, 'ChEMBL: '+searchBarQueryString, search_url_for_query)
      console.log("SEARCHING FOR:"+searchBarQueryString)
      if @atResultsPage
        @searchModel.search(searchBarQueryString)
      else
        # Navigates to the specified URL
        window.location.href = search_url_for_query

    searchAdvanced: () ->
      searchBarQueryString = $('#search_bar').val()
      if @atResultsPage
        @switchShowAdvanced()
      else
        window.location.href = glados.Settings.SEARCH_RESULTS_PAGE+"/"+glados.Settings.SEARCH_RESULTS_PAGE_ADVANCED_PATH+
                "/"+encodeURI(searchBarQueryString)

    switchShowAdvanced: ->
      @showAdvanced = not @showAdvanced
      console.log(@showAdvanced)

    # --------------------------------------------------------------------------------------------------------------------
    # Component rendering
    # --------------------------------------------------------------------------------------------------------------------

    render: () ->
      if GlobalVariables.CURRENT_SCREEN_TYPE == glados.Settings.SMALL_SCREEN
        @fillTemplate('BCK-SRB-small')
        $(@el).find('#search-bar-small').pushpin
          top : 106
      else
        @fillTemplate('BCK-SRB-med-and-up')

    fillTemplate: (div_id) ->
      div = $(@el).find('#' + div_id)
      template = $('#' + div.attr('data-hb-template'))
      if div and template
        div.html Handlebars.compile(template.html())
          searchBarQueryStr: @searchModel.get('queryString')
          showAdvanced: @showAdvanced
        # Shows the central div of the page after the search bar loads
        if not @atResultsPage
          $('#MainPageCentralDiv').show()
      else
        console.log("Error trying to render the SearchBarView because the div or the template could not be found")

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

glados.views.SearchResults.SearchBarView.getInstance = () ->
  if not glados.views.SearchResults.SearchBarView.__view_instance
    glados.views.SearchResults.SearchBarView.__view_instance = new glados.views.SearchResults.SearchBarView
  return glados.views.SearchResults.SearchBarView.__view_instance