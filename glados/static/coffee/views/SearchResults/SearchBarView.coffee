# View that renders the search bar and advanced search components
SearchBarView = Backbone.View.extend

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  el: $('#BCK-SRB-wrapper')
  initialize: (searchModel) ->
    @searchModel = SearchModel.getInstance()
    @showAdvanced = false

  # --------------------------------------------------------------------------------------------------------------------
  # Events Handling
  # --------------------------------------------------------------------------------------------------------------------

  events:
    'keyup #search_bar' : 'searchBarKeyUp',
    'change #search_bar' : 'searchBarChange'

  searchBarKeyUp: (e) ->
    console.log($(e.currentTarget).val())

  searchBarChange: (e) ->
    console.log($(e.currentTarget).val())

  # --------------------------------------------------------------------------------------------------------------------
  # Additional Functionalities
  # --------------------------------------------------------------------------------------------------------------------

  switchShowAdvanced: ->
    @showAdvanced = not @showAdvanced

  # --------------------------------------------------------------------------------------------------------------------
  # Component rendering
  # --------------------------------------------------------------------------------------------------------------------

  render: ->
    @fillTemplate('BCK-SRB-med-and-up')
    @fillTemplate('BCK-SRB-small')
    $(@el).find('#search-bar-small').pushpin
      top : 106

  fillTemplate: (div_id) ->
    div = $(@el).find('#' + div_id)
    template = $('#' + div.attr('data-hb-template'))
    console.log(div)
    console.log(template)
    if div and template
      div.html Handlebars.compile(template.html())
        searchBarQueryStr: @searchModel.get('queryString')
        showAdvanced: @showAdvanced
    else
      console.log("Error trying to render because the div or the template could not be found")