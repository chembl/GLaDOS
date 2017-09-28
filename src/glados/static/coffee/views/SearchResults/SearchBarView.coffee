glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the search bar and advanced search components
  SearchBarView: Backbone.View.extend(glados.views.SearchResults.URLFunctions).extend

    # ------------------------------------------------------------------------------------------------------------------
    # Initialization and navigation
    # ------------------------------------------------------------------------------------------------------------------

    initialize: () ->
      @atResultsPage = URLProcessor.isAtSearchResultsPage()
      @searchModel = SearchModel.getInstance()
      @showAdvanced = false

      @expandable_search_bar = ButtonsHelper.createExpandableInput($(@el).find('.chembl-search-bar'))
      @expandable_search_bar.onEnter(@search.bind(@))
      # Rendering and resize events
      @searchModel.on('change:queryString', @updateSearchBarFromModel.bind(@))
      autocompleteElemFind = $(@el).find('.autocomplete-hb')
      console.log autocompleteElemFind
      autocompleteElem = $(autocompleteElemFind[0])
      @autocompleteView = new glados.views.SearchResults.SearchBarAutocompleteView
        el: autocompleteElem
      @autocompleteView.attachSearchBar($(@el).find('.chembl-search-bar'))

      if @atResultsPage
        # Handles the popstate event to reload a search
        @last_location_url = window.location.href
        window.onpopstate = @popStateHandler.bind(@)
        @searchFromURL()

    popStateHandler: ()->
      @atResultsPage = URLProcessor.isAtSearchResultsPage()
      if window.location.href != @last_location_url
        @last_location_url = window.location.href
        if @atResultsPage
          @searchFromURL()
        else
          $(window).scrollTop(0)
          window.location.reload()

    parseURLData: () ->
      @showAdvanced = URLProcessor.isAtAdvancedSearchResultsPage()

    searchFromURL: ->
      console.log 'SEARCHING FROM URL'
      @parseURLData()
      urlQueryString = decodeURI(URLProcessor.getSearchQueryString())
      if urlQueryString != @lastURLQuery
        @expandable_search_bar.val(urlQueryString)
        @searchModel.search(urlQueryString, null)
        @lastURLQuery = urlQueryString

    # ------------------------------------------------------------------------------------------------------------------
    # Events Handling
    # ------------------------------------------------------------------------------------------------------------------

    events:
      'click .example-link' : 'searchExampleLink'
      'click .search-button' : 'search'
      'click .search-opts' : 'searchAdvanced'

    updateSearchBarFromModel: (e) ->
      if @expandable_search_bar
        @expandable_search_bar.val(@searchModel.get('queryString'))

    searchExampleLink: (e) ->
      exampleString = $(e.currentTarget).html()
      @expandable_search_bar.val(exampleString)
      @search()

    # ------------------------------------------------------------------------------------------------------------------
    # Additional Functionalities
    # ------------------------------------------------------------------------------------------------------------------

    search: () ->
      # Updates the navigation URL
      search_url_for_query = @getCurrentSearchURL()
      window.history.pushState({}, 'ChEMBL: '+@expandable_search_bar.val(), search_url_for_query)
      console.log("SEARCHING FOR:"+@expandable_search_bar.val())
      if @atResultsPage
        @searchModel.search(@expandable_search_bar.val(), null)
      else
        # Navigates to the specified URL
        window.location.href = search_url_for_query

    searchAdvanced: () ->
      searchBarQueryString = @expandable_search_bar.val()
      if @atResultsPage
        @switchShowAdvanced()
      else
        window.location.href = glados.Settings.SEARCH_RESULTS_PAGE+"/"+glados.Settings.SEARCH_RESULTS_PAGE_ADVANCED_PATH+
                "/"+encodeURI(searchBarQueryString)

    switchShowAdvanced: ->
      @showAdvanced = not @showAdvanced

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

glados.views.SearchResults.SearchBarView.createInstances = () ->
  glados.views.SearchResults.SearchBarView.BCKSRBInstance = undefined
  if $('#BCK-SRB-wrapper').length == 1
    glados.views.SearchResults.SearchBarView.BCKSRBInstance = new glados.views.SearchResults.SearchBarView
      el: $('#BCK-SRB-wrapper')
  glados.views.SearchResults.SearchBarView.HeaderInstance = undefined
  if $('#chembl-header-search-bar-container').length == 1
    glados.views.SearchResults.SearchBarView.HeaderInstance = new glados.views.SearchResults.SearchBarView
      el: $('#chembl-header-search-bar-container')