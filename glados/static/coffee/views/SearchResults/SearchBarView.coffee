# View that renders the search bar and advanced search components
SearchBarView = Backbone.View.extend

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  el: $('#BCK-SRB-wrapper')
  initialize: (searchModel) ->
    @searchModel = SearchModel.getInstance()
    @showAdvanced = URLProcessor.isAtAdvancedSearchResultsPage()
    @atResultsPage = URLProcessor.isAtSearchResultsPage()
    if @atResultsPage
      urlQueryString = URLProcessor.getSearchQueryString()
      if urlQueryString
        @searchModel.set('queryString',urlQueryString)
        @search()
    @render()

  # --------------------------------------------------------------------------------------------------------------------
  # Events Handling
  # --------------------------------------------------------------------------------------------------------------------

  events:
    'click .example_link' : 'searchExampleLink'
    'click #submit_search' : 'search'
    'click #search-opts' : 'searchAdvanced'
    'keyup #search_bar' : 'searchBarKeyUp',
    'change #search_bar' : 'searchBarChange'


  searchBarKeyUp: (e) ->
    if e.which == 13
      @search()

  searchBarChange: (e) ->
    console.log($(e.currentTarget).val())

  searchExampleLink: (e) ->
    exampleString = $(e.currentTarget).html()
    @searchModel.set('queryString',exampleString)
    @search()

  # --------------------------------------------------------------------------------------------------------------------
  # Additional Functionalities
  # --------------------------------------------------------------------------------------------------------------------

  search: () ->
    if @atResultsPage
      @searchModel.search()
    else
      window.location.href = Settings.SEARCH_RESULTS_PAGE+"/"+@searchModel.get('queryString')

  searchAdvanced: () ->
    if @atResultsPage
      @switchShowAdvanced()
    else
      window.location.href = Settings.SEARCH_RESULTS_PAGE+"/"+Settings.SEARCH_RESULTS_PAGE_ADVANCED_PATH+"/"+@searchModel.get('queryString')

  switchShowAdvanced: ->
    @showAdvanced = not @showAdvanced
    console.log(@showAdvanced)

  # --------------------------------------------------------------------------------------------------------------------
  # Component rendering
  # --------------------------------------------------------------------------------------------------------------------

  render: () ->
    @fillTemplate('BCK-SRB-med-and-up')
    @fillTemplate('BCK-SRB-small')
    $(@el).find('#search-bar-small').pushpin
      top : 106

  fillTemplate: (div_id) ->
    div = $(@el).find('#' + div_id)
    template = $('#' + div.attr('data-hb-template'))
    if div and template
      div.html Handlebars.compile(template.html())
        searchBarQueryStr: @searchModel.get('queryString')
        showAdvanced: @showAdvanced
    else
      console.log("Error trying to render the SearchBarView because the div or the template could not be found")
