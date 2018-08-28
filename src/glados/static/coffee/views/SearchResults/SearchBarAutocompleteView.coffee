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
      @linkWindowScrollResize()

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
      @$barElem.parent().append('<div class="search-bar-autocomplete-wrapper"/>')
      @$autocompleteWrapperDiv = @$barElem.parent().find('.search-bar-autocomplete-wrapper')
      @registerRecalculatePositioningEvents()

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

    getDebouncedResizeHandler: ()->
      handler = ()->
        return
      handler = handler.bind(@)
      return _.debounce(handler, 200)

    linkTooltipOptions: (event, api)->
      @currentWindowOffset = $(window).scrollTop()

    unlinkTooltipOptions: (event, api)->
      @$options = null

    linkWindowScrollResize: ->
      thisView = @
      scrollNResize = ()->
        hideOnScroll = thisView.currentWindowOffset? and
          Math.abs(thisView.currentWindowOffset-$(window).scrollTop()) > 100
        if thisView.hideQtip? and hideOnScroll
          thisView.hideQtip()
      $(window).scroll scrollNResize
      $(window).resize scrollNResize

    registerRecalculatePositioningEvents: ()->
      bindedCall = @recalculatePositioning.bind(@)
      $(window).scroll bindedCall
      $(window).resize bindedCall
      @$barElem.resize bindedCall


    recalculatePositioning: ()->
      if not _.has(@, '__recalculatePositioning')
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
        @$autocompleteWrapperDiv.show()

glados.views.SearchResults.SearchBarAutocompleteView.ID_COUNT = 0
