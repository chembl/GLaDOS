Compound3DViewSpeck = Backbone.View.extend

  initialize: (options) ->
    @model.on 'change:current3DXYZData', @render, @
    @model.on 'change:xyz3DError', @renderError, @
    @model.on 'change:sdf3DError', @renderError, @
    @model.on 'change:sdf2DError', @renderError, @
    @type = options.type

    @supportsWebGL =  @supportsWebGL()

  events: ->
    'click #BCK-Compound-3d-speckpresets input': 'selectPreset'

  render: ->

    if @supportsWebGL

      $(@el).html(Handlebars.compile($(@typeToTemplate[@type]).html())({}))
      if not @model.get('current3DXYZData')?
        $(@el).find('.BCK-loadingcoords').show()
        delete @molVis
      else
        draw = ()->
          if $('#render-container').is(":visible")
            $(@el).find('.BCK-loadingcoords').hide()
            @molVis = new MoleculeVisualisator("render-container", "renderer-canvas", @model.get('current3DXYZData'))
        draw = draw.bind(@)
        setTimeout(draw, 300)
    else
      @showError('WebGL does not seem to be available in this browser.')

  renderError: ()->
    if @model.get('sdf3DError') or @model.get('sdf2DError') or @model.get('xyz3DError')
      @showError('There was an error obtaining the coordinates from the server.')

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





