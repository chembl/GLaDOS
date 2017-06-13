MiniHistogramView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->
    @model.on 'change', @render, @
    @$vis_elem = $(@el).find('.BCK-mini-histogram-container')
    updateViewProxy = @setUpResponsiveRender()
    @showPreloader()

  showPreloader: -> glados.Utils.fillContentForElement(@$vis_elem, {}, 'Handlebars-Common-MiniRepCardPreloader')

  render: ->
    @$vis_elem.empty()
    buckets =  @model.get('pie-data')

    if buckets.length == 0
      $visualisationMessages = $(@el).find('.BCK-VisualisationMessages')
      $visualisationMessages.html('No data.')
      return

    console.log 'RENDER VIEW!', buckets