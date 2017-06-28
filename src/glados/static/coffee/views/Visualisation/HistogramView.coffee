glados.useNameSpace 'glados.views.Visualisation',
  HistogramView: Backbone.View.extend(ResponsiviseViewExt).extend
    initialize:  ->
      console.log 'INITIALIZING HISTOGRAM!!!'
      @$vis_elem = $(@el).find('.BCK-HistogramContainer')
      updateViewProxy = @setUpResponsiveRender()

      @config = arguments[0].config
      @paintAxesSelectors()
      @showPreloader()

    paintAxesSelectors: ->
      $xAxisSelector = $(@el).find('.BCK-ESResultsPlot-selectXAxis')
      glados.Utils.fillContentForElement $xAxisSelector,
        options: ($.extend(@config.properties[opt], {id:opt, selected: opt == @config.initial_property_x}) for opt in @config.x_axis_options)

      $(@el).find('select').material_select()

    showPreloader: ->
      glados.Utils.fillContentForElement(@$vis_elem, {}, 'Handlebars-Common-Preloader')

    render: ->
      console.log 'RENDER HISTOGRAM!'

