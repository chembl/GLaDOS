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
      @$options = []
      @numSuggestions = 0

    attachSearchBar: (barId)->
      @barId= barId
      $('#'+barId).bind(
        'keyup',
        @barKeyupHandler.bind(@)
      )
      $('#'+barId).bind(
        'keydown',
        @barKeydownHandler.bind(@)
      )

    barKeydownHandler: (keyEvent)->
      # Up key code
      if keyEvent.which == 38
        if @numSuggestions > 0
          @$options[@numSuggestions-1].focus()
        keyEvent.preventDefault()
      # Down key code
      else if keyEvent.which == 40
        if @numSuggestions > 0
          @$options[0].focus()
        keyEvent.preventDefault()

    barKeyupHandler: (keyEvent)->
      if $('#'+@barId).val().length >= 3
        searchText = $('#'+@barId).val()
        if @lastSearch != searchText
          @searchModel.requestAutocompleteSuggestions searchText
          @lastSearch = searchText
      else
        @searchModel.set 'autocompleteSuggestions',[]

    getKeydownListenerForSuggestionN: (n)->
      return (keyEvent)->
        # Up key code
        if keyEvent.which == 38
          if n == 0 and @numSuggestions > 0
            $('#'+@barId).focus()
          else if n < @numSuggestions
            @$options[n-1].focus()
          keyEvent.preventDefault()
        # Down key code
        else if keyEvent.which == 40
          if n < @numSuggestions-1
            @$options[n+1].focus()
          else if n == @numSuggestions-1
            $('#'+@barId).focus()
          keyEvent.preventDefault()


    linkTooltipOptions: (event, api)->
      #AutoCompleteTooltip
      $act = $('#search-bar-autocomplete-tooltip')
      @$options = []
      for n in [0..@numSuggestions]
        $optionN = $act.find('.autocomplete-option-'+n)
        $optionN.bind(
          'keydown',
          @getKeydownListenerForSuggestionN(n).bind(@)
        )
        @$options.push $optionN

    unlinkTooltipOptions: (event, api)->
      @$options = null

    updateAutocomplete: ()->
      $hoveredElem = $('#'+@barId)
      autocompleteSuggestions = @searchModel.get('autocompleteSuggestions')
      @numSuggestions = autocompleteSuggestions.length
      if autocompleteSuggestions.length > 0
        if not @qtipAPI
          qtipConfig =
            content:
              text: ''
            events:
              show: @linkTooltipOptions.bind(@)
            hide:
              event: 'unfocus'
            position:
              my: 'top left'
              at: 'bottom left'
            show:
              solo: true
            style:
              width: $hoveredElem.width()
              classes:'simple-qtip qtip-light qtip-shadow'
          $hoveredElem.qtip qtipConfig
          @qtipAPI = $hoveredElem.qtip('api')

        $hoveredElem.qtip 'option', 'content.text', $(@suggestionsTemplate({
          suggestions: autocompleteSuggestions
          textSearch: @lastSearch
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