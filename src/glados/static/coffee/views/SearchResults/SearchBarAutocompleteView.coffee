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
        # Up key code
        if upElement and keyEvent.which == 38
          upElement.focus()
          keyEvent.preventDefault()
        # Down key code
        else if downElement and keyEvent.which == 40
          downElement.focus()
          keyEvent.preventDefault()
        # Right key code
        else if rightElement and keyEvent.which == 39
          rightElement.focus()
          keyEvent.preventDefault()
        # Left key code
        else if leftElement and keyEvent.which == 37
          leftElement.focus()
          keyEvent.preventDefault()


    linkTooltipOptions: (event, api)->
      #AutoCompleteTooltip
      $act = $('#search-bar-autocomplete-tooltip')
      @$options = []
      @$optionsReportCards = []
      autocompleteSuggestions = @searchModel.get('autocompleteSuggestions')
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
        if @$optionsReportCards[n]
          @$optionsReportCards[n].bind(
            'keydown',
            @getKeydownListenerForSuggestionN(n, true).bind(@)
          )

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