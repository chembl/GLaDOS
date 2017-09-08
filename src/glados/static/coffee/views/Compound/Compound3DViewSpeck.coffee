Compound3DViewSpeck = Backbone.View.extend

  initialize: (options) ->
    @model.on 'change:current3DXYZData', @render, @
    @type = options.type

    @supportsWebGL =  @supportsWebGL()

  events: ->
    'click #BCK-Compound-3d-speckpresets input': 'selectPreset'

  render: ->

    if @supportsWebGL

      $(@el).html(Handlebars.compile($(@typeToTemplate[@type]).html())({}))
      if not @model.get('current3DXYZData')?
        $('#BCK-loadingcoords').show()
        delete @molVis
      else
        draw = ()->
          if $('#render-container').is(":visible")
            $('#BCK-loadingcoords').hide()
            @molVis = new MoleculeVisualisator("render-container", "renderer-canvas", @model.get('current3DXYZData'))
        draw = draw.bind(@)
        setTimeout(draw, 300)
    else
      @showError('WebGL does not seem to be available in this browser.')

  showError: (msg) ->
    $(@el).html Handlebars.compile($('#Handlebars-Compound-3D-error').html())
      msg: msg

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





