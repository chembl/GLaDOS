glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the search bar and advanced search components
  SearchBarView: Backbone.View.extend(glados.views.SearchResults.URLFunctions).extend

    # ------------------------------------------------------------------------------------------------------------------
    # Initialization and navigation
    # ------------------------------------------------------------------------------------------------------------------

    el: $('#BCK-SRB-wrapper')
    initialize: () ->
      @atResultsPage = URLProcessor.isAtSearchResultsPage()
      @searchModel = SearchModel.getInstance()
      @showAdvanced = false
      @expandable_search_bar = null # Assigned after render
      @small_bar_id = 'BCK-SRB-small'
      @med_andup_bar_id = 'BCK-SRB-med-and-up'
      # re-renders on widnow resize
      @last_screen_type_rendered = null
      # Render variables
      @resultsListsViewsRendered = false
      @$searchResultsListsContainersDict = null
      @browsersDict = null
      @container = null
      @lists_container = null

      # Rendering and resize events
      @render()
      $(window).resize(@render.bind(@))
      @searchModel.on('change:queryString', @updateSearchBarFromModel.bind(@))

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
      'click .example_link' : 'searchExampleLink'
      'click #submit_search' : 'search'
      'click #search-opts' : 'searchAdvanced'

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

    # ------------------------------------------------------------------------------------------------------------------
    # Component rendering
    # ------------------------------------------------------------------------------------------------------------------

    render: ->
      if @last_screen_type_rendered != GlobalVariables.CURRENT_SCREEN_TYPE
        # on re-render cleans the drawn bar
        $(@el).find('#'+@small_bar_id+',#'+@med_andup_bar_id).html('')
        if GlobalVariables.CURRENT_SCREEN_TYPE == glados.Settings.SMALL_SCREEN
          @fillTemplate(@small_bar_id)
          $(@el).find('#search-bar-small').pushpin
            top : 106
        else
          @fillTemplate(@med_andup_bar_id)

        @last_screen_type_rendered = GlobalVariables.CURRENT_SCREEN_TYPE

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

        # expandable search bar
        @expandable_search_bar = ButtonsHelper.createExpandableInput($(@el).find('#search_bar'))
        @expandable_search_bar.onEnter(@search.bind(@))
        setTimeout(
          ()->
            glados.views.SearchResults.SearchBarAutocompleteView.getInstance().attachSearchBar('search_bar')
          , 1000
        )
      else
        console.log("Error trying to render the SearchBarView because the div or the template could not be found")

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

glados.views.SearchResults.SearchBarView.getInstance = () ->
  if not glados.views.SearchResults.SearchBarView.__view_instance
    glados.views.SearchResults.SearchBarView.__view_instance = new glados.views.SearchResults.SearchBarView
  return glados.views.SearchResults.SearchBarView.__view_instance