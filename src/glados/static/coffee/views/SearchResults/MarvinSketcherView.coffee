# View that renders the marvin sketcher and handles all the communication with it.
MarvinSketcherView = Backbone.View.extend

  # Search types
  SIMILARITY_SEARCH: 'similarity'
  SUBSTRUCTURE_SEARCH: 'substructure'

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  el: $('#BCK-MarvinContainer')

  initialize: ->
    thisView = @

    MarvinJSUtil.getEditor('#sketch').then ((sketcherInstance) ->
      thisView.marvinSketcherInstance = sketcherInstance
    ), (error) ->
      alert 'Loading of the sketcher failed' + error

    $(@el).find('select').material_select();

  # --------------------------------------------------------------------------------------------------------------------
  # Events Handling
  # --------------------------------------------------------------------------------------------------------------------

  events:
    'click .marvin-search-btn': 'triggerMarvinSearch'
    'change .select-type-of-search': 'selectSearchType'
    'input .similarity-search-threshold-input': 'updatePercentageField'
    'change .similarity-search-threshold-input': 'updatePercentageField'

  # --------------------------------------------------------------------------------------------------------------------
  # Sketcher Handling
  # --------------------------------------------------------------------------------------------------------------------

  # gets the parameters and what the user drew in the sketcher to then perform a search with it.
  triggerMarvinSearch: ->

    if @marvinSketcherInstance.isEmpty()
      $(@el).find('.messages-to-user').text('Please draw a structure first!')
      return

    $(@el).find('.messages-to-user').text('Processing structure...')

    thisView = @
    @marvinSketcherInstance.exportStructure('mol').then ((data) ->
      console.log 'structure received: ', data

      url_and_data = {}
      # Don't add the last slash, you will get the "No 'Access-Control-Allow-Origin' header" issue
      url_and_data.url = glados.Settings.BEAKER_BASE_URL + 'ctab2smiles'
      url_and_data.data = data

      $.post(url_and_data.url, url_and_data.data).done( (smiles) ->

        $(thisView.el).find('.messages-to-user').text('Searching...')

        if thisView.searchType == @SUBSTRUCTURE_SEARCH
          searchUrl = glados.Settings.SUBSTRUCTURE_SEARCH_RESULTS_PAGE + smiles.split('\n')[1].trim()
        else
          percentage = $(thisView.el).find('.similarity-search-threshold-input').val()
          searchUrl = glados.Settings.SIMILARITY_SEARCH_RESULTS_PAGE + smiles.split('\n')[1].trim() + '/' + percentage

        window.location.href =  searchUrl

      )


    ), (error) ->
      $(@el).find('.messages-to-user').text('There was an error: ' + error)

  selectSearchType: (event) ->

    selector = $(event.currentTarget)
    searchType = selector.val()

    if searchType == ''
      return

    @searchType = searchType

    if @searchType == @SIMILARITY_SEARCH
      $(@el).find('.similarity-search-threshold').slideDown('Slow')
    else
      $(@el).find('.similarity-search-threshold').slideUp('Slow')

  updatePercentageField: (event) ->

    selector = $(event.currentTarget)
    percentage = selector.val()

    $(@el).find('.similarity-search-threshold-text').text Handlebars.compile( $('#Handlebars-Marvin-Similarity-Percentage').html() )
      percentage: percentage



