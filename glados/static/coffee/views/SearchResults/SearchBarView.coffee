# View that renders a list of resulting compounds as paginated cards.
SearchBarView = Backbone.View.extend

  initialize: searchModel ->
    @searchModel = searchModel
    @showAdvanced = false

  events:
    'change input#search_bar' : 'changeSearchBar'

  switchShowAdvanced: ->
    @showAdvanced = not @showAdvanced

  changeSearchBar: (e) ->
    console.log($(e.currentTarget).val())

