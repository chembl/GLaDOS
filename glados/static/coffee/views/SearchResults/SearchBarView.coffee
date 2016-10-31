# View that renders the search bar and advanced search components
SearchBarView = Backbone.View.extend

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  el: $('#BCK-SRB-wrapper')
  initialize: (searchModel) ->
    @searchModel = SearchModel.getInstance()
    @showAdvanced = false
    @atResultsPage = URLProcessor.isAtSearchResultsPage()
    if @atResultsPage
      urlQueryString = URLProcessor.getSearchQueryString()
      if urlQueryString
        @searchModel.set('queryString',urlQueryString)
        @search()
      else
        @showAdvanced = true
    @render()

  # --------------------------------------------------------------------------------------------------------------------
  # Events Handling
  # --------------------------------------------------------------------------------------------------------------------

  events:
    'click #submit_search_1' : 'search'
    'click #submit_search_2' : 'search'
    'keyup #search_bar' : 'searchBarKeyUp',
    'change #search_bar' : 'searchBarChange'


  searchBarKeyUp: (e) ->
    if e.which == 13
      @search()

  searchBarChange: (e) ->
    console.log($(e.currentTarget).val())

  # --------------------------------------------------------------------------------------------------------------------
  # Additional Functionalities
  # --------------------------------------------------------------------------------------------------------------------

  search: () ->
    if @atResultsPage:
      @searchModel.search()
    else
      window.location.href = Settings.SEARCH_RESULTS_PAGE+"/"+@searchModel.get('queryString')

  switchShowAdvanced: ->
    @showAdvanced = not @showAdvanced

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
