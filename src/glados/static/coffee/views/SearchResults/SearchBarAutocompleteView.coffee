glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the autocomplete search bar functionality
  SearchBarAutocompleteView: Backbone.View.extend

    # ------------------------------------------------------------------------------------------------------------------
    # Initialization
    # ------------------------------------------------------------------------------------------------------------------

    initialize: ->
      console.log 'INIT AUTOCOMPLETE VIEW'
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
      # Override the default on enter of the search bar
      @searchBarView.expandable_search_bar.onEnter(@barOnEnterCallback.bind(@))
      @registerRecalculatePositioningEvents()

    # ------------------------------------------------------------------------------------------------------------------
    # Bar Event Handling
    # ------------------------------------------------------------------------------------------------------------------
    showPreloader: ->

      console.log 'SHOW PRELOADER!!!'

    barFocusHandler: (event)->
      @updateSelected true
      if @$autocompleteWrapperDiv?
        if @numSuggestions == 0
          @$autocompleteWrapperDiv.hide()
        else
          @$autocompleteWrapperDiv.show()

    barBlurHandler: (event)->
      @updateSelected true
      if @$autocompleteWrapperDiv? and not @$autocompleteWrapperDiv.is(":hover")
        @$autocompleteWrapperDiv.hide()

    barKeydownHandler: (keyEvent)->
      # Up key code
      if keyEvent.which == 38
        if @currentSelection == - 1
          @currentSelection = @autocompleteSuggestions.length - 1
        else
          @currentSelection--
        @updateSelected()
        keyEvent.preventDefault()
      # Down key code
      else if keyEvent.which == 40
        if @currentSelection == @autocompleteSuggestions.length - 1
          @currentSelection = -1
        else
          @currentSelection++
        @updateSelected()
        keyEvent.preventDefault()

    barKeyupHandler: (keyEvent)->

      searchText = @$barElem.val().trim()
      isUpOrDownOrEnter = keyEvent.which == 38 or keyEvent.which == 40 or keyEvent.which  == 13
      if not isUpOrDownOrEnter
        @$autocompleteWrapperDiv.hide()

      if searchText.length >= 3

        # only submit the search if the text changes and is not on a selection doing up or down
        if @lastSearch != searchText and (@currentSelection == -1 or not isUpOrDownOrEnter)
          @searchModel.requestAutocompleteSuggestions searchText, @
      else
        @searchModel.set('autocompleteSuggestions', [])
      if not isUpOrDownOrEnter
        @lastSearch = searchText

    registerRecalculatePositioningEvents: ()->
      bindedCall = @recalculatePositioning.bind(@)
      $(window).scroll bindedCall
      $(window).resize bindedCall
      @$barElem.resize bindedCall

    # ------------------------------------------------------------------------------------------------------------------
    # Autocomplete Navigation on Enter or Click
    # ------------------------------------------------------------------------------------------------------------------

    getSuggestion: (suggIndex) ->
      if @autocompleteSuggestions? and suggIndex >= 0 and suggIndex < @autocompleteSuggestions.length
        return @autocompleteSuggestions[suggIndex]
      return null

    search: (suggestion=undefined)->
      searchText = @lastSearch
      selectedEntity = suggestion?.entityKey
      if suggestion?
        if not suggestion.header and not suggestion.multiple_documents
          window.location.href = suggestion.chembl_id_link.href
          return
        else if not suggestion.header
          searchText = suggestion.text
      @searchBarView.search(searchText, selectedEntity)

    barOnEnterCallback: ()->
      suggestion = @getSuggestion(@currentSelection)
      @$barElem.blur()
      @$autocompleteWrapperDiv.hide()
      @search suggestion

    getAutocompleteOptionOnClick: (optionIndex)->
      onClickCall = ()->
        suggestion = @getSuggestion(optionIndex)
        @$barElem.blur()
        @$autocompleteWrapperDiv.hide()
        @search suggestion
      return onClickCall.bind(@)

    assignOnclickCallbacks: ()->
      if @autocompleteSuggestions?
        for suggestionI, i in @autocompleteSuggestions
          clickDiv = @$autocompleteWrapperDiv.find('.ac-option-'+i)
          clickDiv[0].onclick = @getAutocompleteOptionOnClick(i)

    # ------------------------------------------------------------------------------------------------------------------
    # style helpers
    # ------------------------------------------------------------------------------------------------------------------

    updateSelected: (reset=false)->
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
        if @autocompleteSuggestions[@currentSelection].header
          @searchBarView.expandable_search_bar.val @lastSearch
        else
          @searchBarView.expandable_search_bar.val @autocompleteSuggestions[@currentSelection].text
      else if not reset
        @searchBarView.expandable_search_bar.val @lastSearch

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
      console.log 'UPDATE AUTOCOMPLETE'
      if not @$barElem? or not @$barElem.is(":visible")
        return
      if @searchModel.autocompleteCaller != @
        return
      if @$autocompleteWrapperDiv?
        console.log 'THERE IS DIV'
        console.log 'autocompleteSuggestions:', @searchModel.get('autocompleteSuggestions')
        @updateSelected true
        @autocompleteSuggestions = @searchModel.get('autocompleteSuggestions')
        @numSuggestions = @autocompleteSuggestions.length
        @$autoccompleteDiv = @suggestionsTemplate
          suggestions: @autocompleteSuggestions
          textSearch: @lastSearch
        @$autocompleteWrapperDiv.html(@$autoccompleteDiv)
        @assignOnclickCallbacks()
        @recalculatePositioning()
        # Additional check to make sure the shown suggestions belong to the currently displayed text
        if @numSuggestions == 0 or @autocompleteSuggestions[0].autocompleteQuery != @lastSearch
          @$autocompleteWrapperDiv.hide()
        else
          @$autocompleteWrapperDiv.show()
