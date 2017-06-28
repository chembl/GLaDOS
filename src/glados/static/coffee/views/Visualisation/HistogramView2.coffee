glados.useNameSpace 'glados.views.Visualisation',
  HistogramView: Backbone.View.extend(ResponsiviseViewExt).extend
    initialize:  ->
      console.log 'INITIALIZING HISTOGRAM!!!'
      @$vis_elem = $(@el).find('.BCK-HistogramContainer')
      updateViewProxy = @setUpResponsiveRender()

      @config = arguments[0].config
      @paintAxesSelectors()
      @showPreloader()



    render: ->
      console.log 'RENDER HISTOGRAM!'

