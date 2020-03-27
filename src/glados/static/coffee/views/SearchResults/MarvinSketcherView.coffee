# View that renders the marvin sketcher and handles all the communication with it.
MarvinSketcherView = Backbone.View.extend

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------
  sdf_to_load_on_ready: null

  initialize: (options)->
    @preloader = $(@el).find('.marvin-preloader')
    @preloader.show()
    @marvin_iframe = $(@el).find('.sketch-iframe')
    @$messagesToUser = $(@el).find('.messages-to-user')
    @marvinIframeId = 'MarvinJS-editor-'+MarvinSketcherView.CURRENT_EDITOR_ID
    MarvinSketcherView.CURRENT_EDITOR_ID += 1
    @marvin_iframe.attr('id', @marvinIframeId)
    if options
      @sdf_to_load_on_ready = options.sdf_to_load_on_ready
      @smiles_to_load_on_ready = options.smiles_to_load_on_ready
      @custom_initial_similarity = options.custom_initial_similarity
      @chembl_id_to_load_on_ready = options.chembl_id_to_load_on_ready

    @updatePercentageText(@custom_initial_similarity) unless not @custom_initial_similarity?
    @updatePercentageSlider(@custom_initial_similarity) unless not @custom_initial_similarity?

    outerHtml = $('html')
    thisView = @

    MarvinJSUtil.getEditor(@marvinIframeId).then ((sketcherInstance) ->
      thisView.marvinSketcherInstance = sketcherInstance
      empty = false
      innerDoc = thisView.marvin_iframe[0].contentDocument || thisView.marvin_iframe[0].contentWindow.document
      thisView.innerCanvas = $(innerDoc).find('#canvas')
      sketcherInstance.on 'molchange', ->
        empty = sketcherInstance.isEmpty()
        thisView.innerCanvas.focus()
      ButtonsHelper.disableOuterScrollOnMouseEnter thisView.marvin_iframe[0], outerHtml[0]

      thisView.preloader.hide()
      if thisView.sdf_to_load_on_ready
        thisView.loadStructure(thisView.sdf_to_load_on_ready, MarvinSketcherView.SDF_FORMAT)
      else if thisView.smiles_to_load_on_ready
        thisView.loadStructure(thisView.smiles_to_load_on_ready, MarvinSketcherView.SMILES_FORMAT)
      else if thisView.chembl_id_to_load_on_ready
        sdfURL = Compound.getSDFURL(thisView.chembl_id_to_load_on_ready)
        $.get(sdfURL).done( (sdf) ->
          thisView.loadStructure(sdf, MarvinSketcherView.SDF_FORMAT)
        )

    ), (error) ->
      alert 'Loading of the sketcher failed' + error

    $(@el).find('select').material_select();

  # --------------------------------------------------------------------------------------------------------------------
  # Events Handling
  # --------------------------------------------------------------------------------------------------------------------

  events:
    'click .substructure-search-btn': 'triggerSubstructureSearch'
    'click .similarity-search-btn': 'triggerSimilaritySearch'
    'click .flexmatch-search-btn': 'triggerFlexmatchSearch'
    'change .select-type-of-search': 'selectSearchType'
    'input .similarity-search-threshold-input': 'updatePercentageField'
    'change .similarity-search-threshold-input': 'updatePercentageField'
    'click .close-messages-to-user': 'closeMessagesToUser'
    'click .menu-button-close': 'closeMenu'
    'click .menu-button-open': 'openMenu'

  closeMenu: ->
    $(@el).find('.marvinjs-buttons').slideUp()
    $(@el).find('.marvinjs-buttons-closed').slideDown()

  openMenu: ->
    $(@el).find('.marvinjs-buttons-closed').slideUp()
    $(@el).find('.marvinjs-buttons').slideDown()

  # --------------------------------------------------------------------------------------------------------------------
  # Message handling
  # --------------------------------------------------------------------------------------------------------------------

  debouncedCloseMessageBox: _.debounce ->
    thisView = @
    setTimeout ->
      thisView.$messagesToUser.hide()
    , 1000
  , 1000

  closeMessagesToUser: ->
    @.$messagesToUser.hide()

  sendMessageToUser: (msg)->
    @$messagesToUser.find('.message').text(msg)
    @$messagesToUser.show()
    @debouncedCloseMessageBox()


  # --------------------------------------------------------------------------------------------------------------------
  # Sketcher Handling
  # --------------------------------------------------------------------------------------------------------------------

  # gets the parameters and what the user drew in the sketcher to then perform a search with it.
  triggerMarvinSearch: (searchType) ->
    if not @marvinSketcherInstance?
      @sendMessageToUser('Marvin is not ready yet!')
      return

    if @marvinSketcherInstance.isEmpty()
      @sendMessageToUser('Please draw a structure first!')
      return

    @sendMessageToUser('Processing structure...')

    thisView = @
    @marvinSketcherInstance.exportStructure('mol').then ((data) ->

      formData = new FormData()
      molFileBlob = new Blob([data], {type: 'chemical/x-mdl-molfile'})
      formData.append('file', molFileBlob, 'molecule.mol')
      formData.append('sanitize', 0)

      ajaxRequestDict =
        url: glados.Settings.BEAKER_BASE_URL + 'ctab2smiles'
        data: formData
        enctype: 'multipart/form-data'
        processData: false
        contentType: false
        cache: false
      $.post(ajaxRequestDict).done( (smilesData) ->

        if not smilesData? or smilesData.trim().length == 0
          thisView.sendMessageToUser('The drawn molecule could not be parsed to SMILES format!')
          return
        thisView.sendMessageToUser('Searching...')
        smilesLine = smilesData.split('\n')[1].trim()
        smiles = smilesLine.split(' ')[0]
        smiles = encodeURIComponent smiles

        if searchType == MarvinSketcherView.SUBSTRUCTURE_SEARCH
          searchUrl = glados.Settings.SUBSTRUCTURE_SEARCH_RESULTS_PAGE + smiles
        else if searchType == MarvinSketcherView.FLEXMATCH_SEARCH
          searchUrl = glados.Settings.FLEXMATCH_SEARCH_RESULTS_PAGE + smiles
        else
          percentage = $(thisView.el).find('.similarity-search-threshold-input').val()
          searchUrl = glados.Settings.SIMILARITY_SEARCH_RESULTS_PAGE + smiles + '/' + percentage

        window.location.href = searchUrl
        $(thisView.el).modal('close')

      ).error( (error) ->
        thisView.sendMessageToUser('There was an error: ' + error)
      )


    ), (error) ->
      @sendMessageToUser('There was an error: ' + error)

  # --------------------------------------------------------------------------------------------------------------------
  # loading structures
  # --------------------------------------------------------------------------------------------------------------------
  clearStructure: ->

    if not @marvinSketcherInstance?
      MarvinJSUtil.getEditor(@marvinIframeId).then (sketcherInstance) ->
        sketcherInstance.clear()
    else
      @marvinSketcherInstance.clear()

  loadStructure: (load_string, format=MarvinSketcherView.SDF_FORMAT, onlyIfEmpty=false)->
    if onlyIfEmpty and not @marvinSketcherInstance.isEmpty()
      return
    if not @marvinSketcherInstance?
      if format == MarvinSketcherView.SMILES_FORMAT
        @smiles_to_load_on_ready = load_string
      else if format == MarvinSketcherView.SDF_FORMAT
        @sdf_to_load_on_ready = load_string
      return
    @preloader.show()
    load_structure = ->
      if format == MarvinSketcherView.SMILES_FORMAT
        formData = new FormData()
        smilesFileBlob = new Blob([load_string], {type: 'chemical/x-daylight-smiles'})
        formData.append('file', smilesFileBlob, 'molecule.smi')
        formData.append('sanitize', 0)

        ajaxRequestDict =
          url: glados.Settings.BEAKER_BASE_URL + 'smiles2ctab'
          data: formData
          enctype: 'multipart/form-data'
          processData: false
          contentType: false
          cache: false

        getReferenceCTAB = $.post(ajaxRequestDict)

        getReferenceCTAB.done $.proxy((molFileData)->
          @loadStructure(molFileData, MarvinSketcherView.SDF_FORMAT, onlyIfEmpty)
        , @)
      else
        @marvinSketcherInstance.pasteStructure(format, load_string)
        @preloader.hide()
    _.defer load_structure.bind(@)

  triggerSubstructureSearch: ->

    @triggerMarvinSearch(MarvinSketcherView.SUBSTRUCTURE_SEARCH)

  triggerSimilaritySearch: ->

    @triggerMarvinSearch(MarvinSketcherView.SIMILARITY_SEARCH)

  triggerFlexmatchSearch: ->
    @triggerMarvinSearch(MarvinSketcherView.FLEXMATCH_SEARCH)

  updatePercentageField: (event) ->

    selector = $(event.currentTarget)
    percentage = selector.val()
    @updatePercentageText(percentage)

  updatePercentageText: (percentage) ->

    $percentageField = $(@el).find('.similarity-search-threshold-text')
    glados.Utils.fillContentForElement $percentageField,
      percentage: percentage

  updatePercentageSlider: (percentage) ->

    $percentageSlider = $(@el).find('.similarity-search-threshold-slider')
    glados.Utils.fillContentForElement $percentageSlider,
      percentage: percentage

# ----------------------------------------------------------------------------------------------------------------------
# Constants
# ----------------------------------------------------------------------------------------------------------------------

MarvinSketcherView.CURRENT_EDITOR_ID = 0

# Search types
MarvinSketcherView.SIMILARITY_SEARCH = 'similarity'
MarvinSketcherView.SUBSTRUCTURE_SEARCH = 'substructure'
MarvinSketcherView.FLEXMATCH_SEARCH = 'flexmatch'

#format names in marvin
MarvinSketcherView.SDF_FORMAT = 'mol'
MarvinSketcherView.SMILES_FORMAT = 'smiles'
