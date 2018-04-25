glados.useNameSpace 'glados.views.MainPage',
  BrowseEntitiesAsCirclesView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->
      @$vis_elem = $(@el).find('.BCK-circles-Container')
      @setUpResponsiveRender()
      @render()

    render: () ->
      thisView = @
      infoURL = "#{glados.Settings.GLADOS_BASE_PATH_REL}entities_records"

      fetchDatabasePromise = $.getJSON(infoURL)

      fetchDatabasePromise.fail ->
        console.log 'Fetching entities info from web services failed :('

      fetchDatabasePromise.done (response) ->
        thisView.renderCircles(response)


    renderCircles: (data) ->
      console.log 'data: ', data

      @$vis_elem.empty()

      VISUALISATION_WIDTH = $(@el).width()
      VISUALISATION_HEIGHT = VISUALISATION_WIDTH
      MIN_CIRCLE_VALUE = 5
      MAX_CIRCLE_VALUE = 20

      mainContainer = d3.select(@$vis_elem.get(0))
        .append('svg')
          .attr('class', 'mainSVGContaineraa')
          .attr('width', VISUALISATION_WIDTH)
          .attr('height', VISUALISATION_HEIGHT)

      sizes = []
      names = []
      dataList = []
      for key, value of data

        dataItem = {}
        dataItem.key = key
        dataItem.value = value

        dataList.push dataItem
        names.push key
        sizes.push value

#      dataMin= d3.min sizes
#      dataMax = d3.max sizes

#      tam =  d3.scale.linear()
#        .domain(dataMin, dataMax)
#        .range(MIN_CIRCLE_VALUE, MAX_CIRCLE_VALUE)

      mainContainer.selectAll('rect')
        .data(dataList)
        .enter()
        .append('rect')

















