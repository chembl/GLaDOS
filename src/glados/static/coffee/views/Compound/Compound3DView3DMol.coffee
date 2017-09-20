Compound3DView3DMol = Backbone.View.extend

  initialize: ->
    @model.on 'change:current3DData', @render, @
    @model.on 'change:sdf3DError', @renderError, @
    @model.on 'change:sdf2DError', @renderError, @

  render: ()->
    $(@el).find('.error-container').hide()
    current3DData = @model.get('current3DData')

    if not current3DData?
      $(@el).find('.BCK-loadingcoords').show()
      $(@el).find('.visualisation-container').hide()
    else
      draw = ()->
        $(@el).find('.BCK-loadingcoords').hide()
        $(@el).find('.visualisation-container').show()
        if not @molViewer?
          @molViewer = $3Dmol.createViewer($(@el).find('.viewer_3Dmoljs'))
        @molViewer.clear()
        @molViewer.addModel current3DData, '3D_SDF.sdf'
        @molViewer.zoomTo()
        @molViewer.setStyle {}, {stick:{}}
        @molViewer.addSurface $3Dmol.SurfaceType.MS, {opacity:0.85}
        @molViewer.render()
      draw = draw.bind(@)
      setTimeout(draw, 300)

  renderError: ()->
    if @model.get('sdf3DError') or @model.get('sdf2DError')
      @showError('There was an error obtaining the coordinates from the server.')

  showError: (msg) ->
    $(@el).find('.BCK-loadingcoords').hide()
    $(@el).find('.visualisation-container').hide()
    $(@el).find('.error-container').show()
    $(@el).find('.error-container').html Handlebars.compile($('#Handlebars-Compound-3D-error').html())
      msg: msg