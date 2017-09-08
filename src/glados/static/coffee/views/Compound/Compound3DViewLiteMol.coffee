Compound3DViewLiteMol = Backbone.View.extend

  initialize: ->
    @model.on 'change:current3DData', @render, @
    @model.on 'change:sdf3DError', @renderError, @
    @model.on 'change:sdf2DError', @renderError, @

  render: ()->
    current3DData = @model.get('current3DData')

    if not current3DData?
        $(@el).find('.BCK-loadingcoords').show()
        $(@el).find('.visualisation-container').hide()
    else
      draw = ()->
        $(@el).find('.BCK-loadingcoords').hide()
        $(@el).find('.visualisation-container').show()
        sdf3DDataURL = 'data:chemical/x-mdl-sdfile;base64,' + btoa(current3DData)
        $(@el).find('.visualisation-container')\
            .html Handlebars.compile($('#Handlebars-LiteMol-Visualisation').html())
              sdf_url: sdf3DDataURL
        angular.bootstrap($(@el).find('pdb-lite-mol')[0], ['pdb.component.library'])
      draw = draw.bind(@)
      setTimeout(draw, 300)

  renderError: ()->
    if @model.get('sdf3DError') or @model.get('sdf2DError')
      @showError('There was an error obtaining the coordinates from the server.')

  showError: (msg) ->
    $(@el).find('.BCK-loadingcoords').hide()
    $(@el).find('.visualisation-container').show()
    $(@el).find('.visualisation-container').html Handlebars.compile($('#Handlebars-Compound-3D-error').html())
      msg: msg