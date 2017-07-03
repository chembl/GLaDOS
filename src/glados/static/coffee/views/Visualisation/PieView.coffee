# this view is in charge of showing a collection of elements as a pie chart
PieView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->

    @model.on 'change', @render, @
    @$vis_elem = $(@el).find('.BCK-pie-container')
    updateViewProxy = @setUpResponsiveRender()

  render: ->

    buckets =  @model.get('buckets')
    if buckets.length == 0
      $visualisationMessages = $(@el).find('.BCK-VisualisationMessages')
      $visualisationMessages.html('There is no data to show. ' + @model.get('title'))
      return

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
      link = thisView.model.get('buckets_index')[clickedKey].link
      window.open(link)
    )