glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the autocomplete search bar functionality
  SearchBarAutocompleteView: Backbone.View.extend

    # ------------------------------------------------------------------------------------------------------------------
    # Initialization
    # ------------------------------------------------------------------------------------------------------------------

    initialize: () ->
      @suggestionsTemplate = Handlebars.compile $(@el).find('.Handlebars-search-bar-autocomplete').html()
      @searchModel = SearchModel.getInstance()
      @searchModel.on('change:autocompleteSuggestions', @updateAutocomplete.bind(@))
      @$barElem = null
      @$autocompleteWrapperDiv = null
      @lastSearch = null
      @currentSelection = -1
      @numSuggestions = 0
      @autocompleteSuggestions = []
      @searchBarView = null

    attachSearchBar: (searchBarView)->
      @searchBarView = searchBarView
      @$barElem = $(searchBarView.el).find('.chembl-search-bar')
      @$barElem.bind(
        'keyup',@searchBarView
        @barKeyupHandler.bind(@)
      )
      @$barElem.bind(
        'keydown',
        @barKeydownHandler.bind(@)
      )
      @$barElem.bind(
        'blur',
        @barBlurHandler.bind(@)
      )
      @$barElem.bind(
        'focus',
        @barFocusHandler.bind(@)
      )
      @$barElem.parent().append('<div class="search-bar-autocomplete-wrapper"/>')
      @$autocompleteWrapperDiv = @$barElem.parent().find('.search-bar-autocomplete-wrapper')
      @registerRecalculatePositioningEvents()

    # ------------------------------------------------------------------------------------------------------------------
    # Bar Event Handling
    # ------------------------------------------------------------------------------------------------------------------

    barFocusHandler: (event)->
      @updateSelectedCss true
      if @$autocompleteWrapperDiv?
        if @numSuggestions == 0
          @$autocompleteWrapperDiv.hide()
        else
          @$autocompleteWrapperDiv.show()

    barBlurHandler: (event)->
      @updateSelectedCss true
      if @$autocompleteWrapperDiv?
        @$autocompleteWrapperDiv.hide()

    barKeydownHandler: (keyEvent)->
      # Up key code
      if keyEvent.which == 38
        if @currentSelection == - 1
          @currentSelection = @autocompleteSuggestions.length - 1
        else
          @currentSelection--
        @updateSelectedCss()
        keyEvent.preventDefault()
      # Down key code
      else if keyEvent.which == 40
        if @currentSelection == @autocompleteSuggestions.length - 1
          @currentSelection = -1
        else
          @currentSelection++
        @updateSelectedCss()
        keyEvent.preventDefault()

    barKeyupHandler: (keyEvent)->
      if @$barElem.val().length >= 3
        searchText = @$barElem.val().trim()
        if @lastSearch != searchText
          @searchModel.requestAutocompleteSuggestions searchText, @
          @lastSearch = searchText
      else
        @searchModel.set 'autocompleteSuggestions',[]

    registerRecalculatePositioningEvents: ()->
      bindedCall = @recalculatePositioning.bind(@)
      $(window).scroll bindedCall
      $(window).resize bindedCall
      @$barElem.resize bindedCall

    # ------------------------------------------------------------------------------------------------------------------
    # Autocomplete divs Event Handling
    # ------------------------------------------------------------------------------------------------------------------

    getAutocompleteOptionOnClick: (option_index)->
      onClickCall = ()->



    # ------------------------------------------------------------------------------------------------------------------
    # style helpers
    # ------------------------------------------------------------------------------------------------------------------

    updateSelectedCss: (reset=false)->
      if reset
        @currentSelection = -1
        @$autocompleteWrapperDiv.scrollTop 0
      allAtcDivs = @$autocompleteWrapperDiv.find('.autocomplete-option')
      allAtcDivs.removeClass 'selected'
      if @currentSelection >= 0 and @currentSelection < @autocompleteSuggestions.length
        $selectedDiv = $(allAtcDivs[@currentSelection])
        divH = $selectedDiv.height()
        $selectedDiv.addClass 'selected'
        @$autocompleteWrapperDiv.scrollTop @currentSelection*divH


    recalculatePositioning: ()->
      if not _.has(@, '__recalculatePositioning')
        console.debug('Creating new debounced __recalculatePositioning function')
        debouncedCall = ()->
          if @$autocompleteWrapperDiv?
            barPos = @$barElem.position()
            barH = @$barElem.height()
            @$autocompleteWrapperDiv.css
              top: (barPos.top+barH)+'px'
              'max-height': (window.innerHeight*3/4)+'px'
        debouncedCall = _.debounce(debouncedCall.bind(@), 200)
        @__recalculatePositioning = debouncedCall
      @__recalculatePositioning()

    # ------------------------------------------------------------------------------------------------------------------
    # Callback from model
    # ------------------------------------------------------------------------------------------------------------------

    updateAutocomplete: ()->
      if not @$barElem? or not @$barElem.is(":visible")
        return
      if @searchModel.autocompleteCaller != @
        return
      if @$autocompleteWrapperDiv?
        @updateSelectedCss true
        @autocompleteSuggestions = @searchModel.get('autocompleteSuggestions')
        @numSuggestions = @autocompleteSuggestions.length
        @$autoccompleteDiv = @suggestionsTemplate
          suggestions: @autocompleteSuggestions
          textSearch: @lastSearch
        @$autocompleteWrapperDiv.html(@$autoccompleteDiv)
        @recalculatePositioning()
        if @numSuggestions == 0
          @$autocompleteWrapperDiv.hide()
        else
          @$autocompleteWrapperDiv.show()
