glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the autocomplete search bar functionality
  SearchBarAutocompleteView: Backbone.View.extend

    # ------------------------------------------------------------------------------------------------------------------
    # Initialization
    # ------------------------------------------------------------------------------------------------------------------

    initialize: () ->
      @qtipId = 'autocomplete_tooltip__'+glados.views.SearchResults.SearchBarAutocompleteView.ID_COUNT
      glados.views.SearchResults.SearchBarAutocompleteView.ID_COUNT += 1
      @suggestionsTemplate = Handlebars.compile $(@el).find('.Handlebars-search-bar-autocomplete').html()
      @searchModel = SearchModel.getInstance()
      @searchModel.on('change:autocompleteSuggestions', @updateAutocomplete.bind(@))
      @$barElem = null
      @lastSearch = null
      @qtipAPI = null
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
        @getBarKeyupHandler()
      )
      @$barElem.bind(
        'keydown',
        @barKeydownHandler.bind(@)
      )

    barKeydownHandler: (keyEvent)->
      elementToFocus = null
      # Up key code
      if keyEvent.which == 38
        if @numSuggestions > 0
          elementToFocus = @$options[@numSuggestions-1]
        keyEvent.preventDefault()
      # Down key code
      else if keyEvent.which == 40
        if @numSuggestions > 0
          elementToFocus = @$options[0]
        keyEvent.preventDefault()
      else
        elementToFocus = null
      if elementToFocus
        elementToFocus.focus()
        @searchBarView.expandable_search_bar.val elementToFocus.attr("autocomplete-text")

    __barKeyupHandler: (keyEvent)->
      if @$barElem.val().length >= 3
        searchText = @$barElem.val().trim()
        if @lastSearch != searchText
          @searchModel.requestAutocompleteSuggestions searchText, @
          @lastSearch = searchText
      else
        @searchModel.set 'autocompleteSuggestions',[]

    getBarKeyupHandler: ->
      handler = (keyEvent)->
        @__barKeyupHandler(keyEvent)
      handler = handler.bind(@)
      return _.debounce(handler, 200)

    getKeydownListenerForSuggestionN: (n, reportCardLink=false)->
      upElement = null
      downElement = null
      rightElement = null
      leftElement = null
      if not reportCardLink
        if n == 0 and @numSuggestions > 0
          upElement = @$barElem
        else if n < @numSuggestions
          upElement = @$options[n-1]

        if n < @numSuggestions-1
          downElement = @$options[n+1]
        else if n == @numSuggestions-1
          downElement = @$barElem

        if @$optionsReportCards[n]
          rightElement = @$optionsReportCards[n]
          leftElement = rightElement
      else
        leftElement = @$options[n]
        rightElement = leftElement
        loopedOverCount = 0
        curIndex = n
        while loopedOverCount < 2
          if curIndex == 0
            curIndex = @numSuggestions - 1
            loopedOverCount++
          else
            curIndex--
          if @$optionsReportCards[curIndex]
            upElement = @$optionsReportCards[curIndex]
            break
        loopedOverCount = 0
        curIndex = n
        while loopedOverCount < 2
          if curIndex == @numSuggestions - 1
            curIndex = 0
            loopedOverCount++
          else
            curIndex++
          if @$optionsReportCards[curIndex]
            downElement = @$optionsReportCards[curIndex]
            break

      return (keyEvent)->
        elementToFocus = null
        # Up key code
        if upElement and keyEvent.which == 38
          elementToFocus = upElement
          keyEvent.preventDefault()
        # Down key code
        else if downElement and keyEvent.which == 40
          elementToFocus = downElement
          keyEvent.preventDefault()
        # Right key code
        else if rightElement and keyEvent.which == 39
          elementToFocus = rightElement
          keyEvent.preventDefault()
        # Left key code
        else if leftElement and keyEvent.which == 37
          elementToFocus = leftElement
          keyEvent.preventDefault()
        else
          elementToFocus = null
          keyEvent.preventDefault()
          searchVal = @$barElem.val()
          @$barElem.focus()
          @searchBarView.expandable_search_bar.val searchVal
        if elementToFocus
          elementToFocus.focus()
          @searchBarView.expandable_search_bar.val elementToFocus.attr("autocomplete-text")

    getClickListenerForSuggestionN: (n)->
      return (clickEvent)->
        @$barElem.focus()
        @searchBarView.expandable_search_bar.val @$options[n].attr("autocomplete-text")
        @searchBarView.search()

    linkTooltipOptions: (event, api)->
      @currentWindowOffset = $(window).scrollTop()
      #AutoCompleteTooltip
      $act = $('#qtip-'+@qtipId).find('.search-bar-autocomplete-tooltip')
      @$options = []
      @$optionsReportCards = []
      @$barElem.attr("autocomplete-text", @lastSearch)
      for n in [0..@numSuggestions]
        $optionN = $act.find('.autocomplete-option-'+n)
        @$options.push $optionN
        $optionNReportCard = $act.find('.autocomplete-option-rc-link-'+n)
        if $optionNReportCard.length == 0
          $optionNReportCard = null
        @$optionsReportCards.push $optionNReportCard
      # Only bind the events after the arrays are full or there will be reference issues
      for n in [0..@numSuggestions]
        @$options[n].bind(
          'keydown',
          @getKeydownListenerForSuggestionN(n).bind(@)
        )
        @$options[n].bind(
          'click',
          @getClickListenerForSuggestionN(n).bind(@)
        )
        if @$optionsReportCards[n]
          @$optionsReportCards[n].bind(
            'keydown',
            @getKeydownListenerForSuggestionN(n, true).bind(@)
          )

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

    updateAutocomplete: ()->
      if not @$barElem? or not @$barElem.is(":visible")
        return
      if @searchModel.autocompleteCaller != @
        return
      $hoveredElem = @$barElem
      @autocompleteSuggestions = @searchModel.get('autocompleteSuggestions')
      @numSuggestions = @autocompleteSuggestions.length
      if @autocompleteSuggestions.length > 0
        if not @qtipAPI
          qtipConfig =
            id: @qtipId
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
              width: $hoveredElem.parent().parent().parent().width()
              classes:'simple-qtip qtip-light qtip-shadow'
          $hoveredElem.qtip qtipConfig
          @qtipAPI = $hoveredElem.qtip('api')
          @hideQtip = ->
            @$barElem.blur()
            if $('#qtip-'+@qtipId).is(":visible")
              @qtipAPI.hide()
          @hideQtip = @hideQtip.bind(@)

        @qtipAPI.enable()
        $hoveredElem.qtip 'option', 'content.text', $(@suggestionsTemplate({
          suggestions: @autocompleteSuggestions
          textSearch: @lastSearch
        }))
        @qtipAPI.show()
      else if @qtipAPI?
        @qtipAPI.hide()
        @qtipAPI.disable(true)

glados.views.SearchResults.SearchBarAutocompleteView.ID_COUNT = 0