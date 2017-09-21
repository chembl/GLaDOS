Compound3DView3DMol = Backbone.View.extend

  initialize: ->
    @model.on 'change:current3DData', @render, @
    @model.on 'change:sdf3DError', @renderError, @
    @model.on 'change:sdf2DError', @renderError, @

  render: ()->
    if @molViewer
      @molViewer.stopAnimate()
    $(@el).find('.error-container').hide()
    current3DData = @model.get('current3DData')

    if not current3DData?
      $(@el).find('.loadingcoords-preloader').show()
      $(@el).find('.visualisation-container-3D').hide()
    else
      draw = ()->
        $(@el).find('.loadingcoords-preloader').hide()
        $(@el).find('.visualisation-container-3D').show()
        if not @molViewer?
          @molViewer = $3Dmol.createViewer($(@el).find('.viewer-3D'))
        @molViewer.clear()
        @molViewer.setBackgroundColor(0xfffafafa)
        @molViewer.addModel current3DData, '3D_SDF.sdf'
        @molViewer.center()
        @molViewer.zoomTo()
        @molViewer.setStyle {}, {stick:{}}
        @molViewer.addSurface $3Dmol.SurfaceType.MS, {opacity:0.75}
        @molViewer.render()
        @molViewer.rotate(180, 'y', 1500)
      draw = draw.bind(@)
      setTimeout(draw, 300)

  renderError: ()->
    if @model.get('sdf3DError') or @model.get('sdf2DError')
      @showError('There was an error obtaining the coordinates from the server.')


  showError: (msg) ->
    $(@el).find('.loadingcoords-preloader').hide()
    $(@el).find('.visualisation-container-3D').hide()
    $(@el).find('.error-container').show()
    $(@el).find('.error-container').html Handlebars.compile($('#Handlebars-Compound-3D-error').html())
      msg: msg