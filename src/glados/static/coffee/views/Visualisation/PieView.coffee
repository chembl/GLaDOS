# this view is in charge of showing a collection of elements as a pie chart
PieView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->

    @config = arguments[0].config
    @xAxisAggName = @config.x_axis_prop_name
    console.log '@model: ', @model
    @model.on 'change', @render, @
    @$vis_elem = $(@el).find('.BCK-pie-container')
    updateViewProxy = @setUpResponsiveRender()

  render: ->

    if @model.get('state') != glados.models.Aggregations.Aggregation.States.INITIAL_STATE
      return

    if @model.get('state') == glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE

      $visualisationMessages = $(@el).find('.BCK-VisualisationMessages')
      $visualisationMessages.html('There is no data to show. ' + @model.get('title'))
      return

    console.log 'render Pie!!'
    buckets =  @model.get('bucket_data')[@xAxisAggName].buckets
    console.log 'Pie view buckets: ', buckets

    values = []
    labels = []
    for bucket in buckets
      values.push bucket.doc_count
      labels.push bucket.key

    data1 =
      values: values
      labels: labels
      type: 'pie'
      textinfo:'value'

    data = [data1]
    width = @$vis_elem.width()
    layout =
      height: width * (3/5)
      width: width
      title: @model.get('title')

    pieDiv = @$vis_elem.get(0)
    Plotly.newPlot pieDiv, data, layout

    thisView = @
    pieDiv.on('plotly_click', (eventInfo) ->
      clickedKey = eventInfo.points[0].label
      bucketsIndex =  thisView.model.get('bucket_data')[thisView.xAxisAggName].buckets_index
      link = bucketsIndex[clickedKey].link
      window.open(link)
    )