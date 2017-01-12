# View that renders the marvin sketcher and handles all the communication with it.
MarvinSketcherView = Backbone.View.extend

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

  # --------------------------------------------------------------------------------------------------------------------
  # Events Handling
  # --------------------------------------------------------------------------------------------------------------------

  events:
    'click .marvin-search-btn': 'triggerMarvinSearch'

  # --------------------------------------------------------------------------------------------------------------------
  # Sketcher Handling
  # --------------------------------------------------------------------------------------------------------------------

  # gets the parameters and what the user drew in the sketcher to then perform a search with it.
  triggerMarvinSearch: ->

    if @marvinSketcherInstance.isEmpty()
      $(@el).find('.messages-to-user').text('Please draw a structure first!')
      return

    $(@el).find('.messages-to-user').text('Processing structure...')

    console.log 'MARVIN SEARCH!'

    console.log 'supportedFormats: ', @marvinSketcherInstance.getSupportedFormats()

    thisView = @
    @marvinSketcherInstance.exportStructure('mol').then ((data) ->
      console.log 'structure received: ', data

      url_and_data = {}
      # Don't add the last slash, you will get the "No 'Access-Control-Allow-Origin' header" issue
      url_and_data.url = glados.Settings.BEAKER_BASE_URL + 'ctab2smiles'
      url_and_data.data = data

      $.post(url_and_data.url, url_and_data.data).done( (smiles) ->

        $(thisView.el).find('.messages-to-user').text('Searching...')

        console.log( "Data Loaded: " + smiles );

      )


    ), (error) ->
      $(@el).find('.messages-to-user').text('There was an error: ' + error)
