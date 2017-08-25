glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the autocomplete search bar functionality
  SearchBarAutocompleteView: Backbone.View.extend

    # ------------------------------------------------------------------------------------------------------------------
    # Initialization
    # ------------------------------------------------------------------------------------------------------------------

    el: $('#BCK-autocomplete')
    initialize: () ->
      @suggestionsTemplate = Handlebars.compile $('#Handlebars-search-bar-autocomplete').html()
      @searchModel = SearchModel.getInstance()
      @searchBarView = glados.views.SearchResults.SearchBarView.getInstance()
      @searchModel.on('change:autocompleteSuggestions', @updateAutocomplete.bind(@))
      @barId = null
      @lastSearch = null
      @qtipAPI = null

    attachSearchBar: (barId)->
      @barId= barId
      $('#'+barId).bind(
        'keyup',
        @submitAutocompleteRequest.bind(@)
      )

    submitAutocompleteRequest: ()->
      if $('#'+@barId).val().length >= 3
        searchText = $('#'+@barId).val()
        if @lastSearch != searchText
          @searchModel.requestAutocompleteSuggestions searchText
          @lastSearch = searchText
      else
        @searchModel.set 'autocompleteSuggestions',[]

    updateAutocomplete: ()->
      $hoveredElem = $('#'+@barId)
      autocompleteSuggestions = @searchModel.get('autocompleteSuggestions')
      if autocompleteSuggestions.length > 0
        if not @qtipAPI
          qtipConfig =
            content:
              text: ''
            show:
              solo: true
            hide:
              event: 'unfocus'
            position:
              my: 'top left'
              at: 'bottom left'
            style:
              width: $hoveredElem.width()
              classes:'simple-qtip qtip-light qtip-shadow'
          $hoveredElem.qtip qtipConfig
          @qtipAPI = $hoveredElem.qtip('api')

        $hoveredElem.qtip 'option', 'content.text', $(@suggestionsTemplate({
          suggestions: autocompleteSuggestions
        }))
        $hoveredElem.qtip('show')
      else if @qtipAPI
        $hoveredElem.qtip('hide')
      

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

glados.views.SearchResults.SearchBarAutocompleteView.getInstance = () ->
  if not glados.views.SearchResults.SearchBarAutocompleteView.__view_instance
    glados.views.SearchResults.SearchBarAutocompleteView.__view_instance = new glados.views.SearchResults.SearchBarAutocompleteView
  return glados.views.SearchResults.SearchBarAutocompleteView.__view_instance