Compound3DViewSpeck = Backbone.View.extend

  initialize: (options) ->
    @model.on 'change', @.render, @
    @type = options.type

    @supportsWebGL =  @supportsWebGL()

  events: ->
    'click #BCK-Compound-3d-speckpresets input': 'selectPreset'

  render: ->

    if @supportsWebGL
      $(@el).html Handlebars.compile($(@typeToTemplate[@type]).html())
        title: '3D View of ' + @model.get('molecule_chembl_id')
      @getCoordsAndPaint()
    else
      @showError('WebGL does not seem to be available in this browser.')

  showError: (msg) ->
    $(@el).html Handlebars.compile($('#Handlebars-Compound-3D-error').html())
      msg: msg

  getCoordsAndPaint: ->

    $('#BCK-loadingcoords').show()

    standardInchi = @model.get('molecule_structures')['standard_inchi']
    standardInchiB64 = window.btoa(standardInchi)

    molUrl = Settings.BEAKER_BASE_URL + 'inchi2ctab/' + standardInchiB64

    # from a ctab value it returns the base64 url to get the xyz
    getXYZURL = (data) ->
      url_and_data = {}
      # Don't add the last slash, you will get the "No 'Access-Control-Allow-Origin' header" issue
      url_and_data.url = Settings.BEAKER_BASE_URL + 'ctab2xyz'
      url_and_data.data = data

      return url_and_data

    getXZYcontent = (url_and_data) ->
      r = $.ajax( {type: "POST", url: url_and_data.url, data: url_and_data.data})

    setXYZToModelAndPaint = (xyzCoords) ->
      $('#BCK-loadingcoords').hide()
      @model.set('xyz', xyzCoords, {silent: true})
      @molVis = new MoleculeVisualisator("render-container", "renderer-canvas", @model.get('xyz'))

    f = $.proxy(setXYZToModelAndPaint, @)

    getCoords = $.ajax( molUrl ).then(getXYZURL).then(getXZYcontent)
    getCoords.done(f)

    e = $.proxy(@showError, @)
    getCoords.fail ->
      e('There was en error loading the data')


  selectPreset: (event) ->
    value = $(event.currentTarget).val()
    @molVis.changePreset(value)

  typeToTemplate:
    'reduced': '#Handlebars-Compound-3D-speck'

  supportsWebGL: ->

    try
      canvas = document.createElement('canvas')
      return window.WebGLRenderingContext? and (canvas.getContext('webgl')? or canvas.getContext('experimental-webgl'))?
    catch e
      return false





