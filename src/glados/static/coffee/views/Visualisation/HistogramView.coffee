glados.useNameSpace 'glados.views.Visualisation',
  HistogramView: Backbone.View.extend(ResponsiviseViewExt).extend
    initialize:  ->
      console.log 'INITIALIZING HISTOGRAM!!!'
      @$vis_elem = $(@el).find('.BCK-HistogramContainer')
      updateViewProxy = @setUpResponsiveRender()
      @showPreloader()

    showPreloader: ->
      glados.Utils.fillContentForElement(@$vis_elem, {}, 'Handlebars-Common-Preloader')

    render: ->
      console.log 'RENDER HISTOGRAM!'

