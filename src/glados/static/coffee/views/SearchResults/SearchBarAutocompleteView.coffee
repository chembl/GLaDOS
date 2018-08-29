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
      @$options = []
      @$optionsReportCards = []
      @numSuggestions = 0
      @autocompleteSuggestions = []

    attachSearchBar: (searchBarView)->
      @searchBarView = searchBarView
      @$barElem = $(searchBarView.el).find('.chembl-search-bar')
      @$barElem.bind(
        'keyup',
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
      if @$autocompleteWrapperDiv?
        if @numSuggestions == 0
          @$autocompleteWrapperDiv.hide()
        else
          @$autocompleteWrapperDiv.show()

    barBlurHandler: (event)->
      if @$autocompleteWrapperDiv?
        @$autocompleteWrapperDiv.hide()

    barKeydownHandler: (keyEvent)->
      # Up key code
      if keyEvent.which == 38
        down = false
        keyEvent.preventDefault()
      # Down key code
      else if keyEvent.which == 40
        down = true
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
    # Bar Event Handling
    # ------------------------------------------------------------------------------------------------------------------

    recalculatePositioning: ()->
      if not _.has(@, '__recalculatePositioning')
        console.debug('Creating new debounced __recalculatePositioning function')
        debouncedCall = ()->
          if @$autocompleteWrapperDiv?
            barPos = @$barElem.position()
            barH = @$barElem.height()
            barW = @$barElem.parent().width()
            @$autocompleteWrapperDiv.css
              top: (barPos.top+barH)+'px'
              'max-height': (window.innerHeight*3/4)+'px'
        debouncedCall = _.debounce(debouncedCall.bind(@), 200)
        @__recalculatePositioning = debouncedCall
      @__recalculatePositioning()

    updateAutocomplete: ()->
      if not @$barElem? or not @$barElem.is(":visible")
        return
      if @searchModel.autocompleteCaller != @
        return
      if @$autocompleteWrapperDiv?
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
