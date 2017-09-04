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
      @$optionsReportCards = []
      @numSuggestions = 0
      @autocompleteSuggestions = []

    attachSearchBar: (barId)->
      @barId= barId
      $('#'+barId).bind(
        'keyup',
        @getBarKeyupHandler()
      )
      $('#'+barId).bind(
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
        $('#'+@barId).val elementToFocus.attr("autocomplete-text")

    __barKeyupHandler: (keyEvent)->
      if $('#'+@barId).val().length >= 3
        searchText = $('#'+@barId).val().trim()
        if @lastSearch != searchText
          @searchModel.requestAutocompleteSuggestions searchText
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
          upElement = $('#'+@barId)
        else if n < @numSuggestions
          upElement = @$options[n-1]

        if n < @numSuggestions-1
          downElement = @$options[n+1]
        else if n == @numSuggestions-1
          downElement = $('#'+@barId)

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
          searchVal = $('#'+@barId).val()
          $('#'+@barId).focus()
          $('#'+@barId).val searchVal
        if elementToFocus
          elementToFocus.focus()
          $('#'+@barId).val elementToFocus.attr("autocomplete-text")

    getClickListenerForSuggestionN: (n)->
      return (clickEvent)->
        $('#'+@barId).focus()
        $('#'+@barId).val @$options[n].attr("autocomplete-text")
        $('#'+@barId).qtip('hide')
        @qtipAPI.disable(true)

    linkTooltipOptions: (event, api)->
      #AutoCompleteTooltip
      $act = $('#search-bar-autocomplete-tooltip')
      @$options = []
      @$optionsReportCards = []
      $('#'+@barId).attr("autocomplete-text", @lastSearch)
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

    updateAutocomplete: ()->
      $hoveredElem = $('#'+@barId)
      @autocompleteSuggestions = @searchModel.get('autocompleteSuggestions')
      @numSuggestions = @autocompleteSuggestions.length
      if @autocompleteSuggestions.length > 0
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

        @qtipAPI.enable()
        $hoveredElem.qtip 'option', 'content.text', $(@suggestionsTemplate({
          suggestions: @autocompleteSuggestions
          textSearch: @lastSearch
        }))
        $hoveredElem.qtip('show')
      else if @qtipAPI
        $hoveredElem.qtip('hide')
        @qtipAPI.disable(true)

      

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

glados.views.SearchResults.SearchBarAutocompleteView.getInstance = () ->
  if not glados.views.SearchResults.SearchBarAutocompleteView.__view_instance
    glados.views.SearchResults.SearchBarAutocompleteView.__view_instance = new glados.views.SearchResults.SearchBarAutocompleteView
  return glados.views.SearchResults.SearchBarAutocompleteView.__view_instance