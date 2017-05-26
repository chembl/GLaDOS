# this view is in charge of showing a collection of elements as a pie chart
PieView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->

    @model.on 'change', @render, @
    @$vis_elem = $(@el).find('.BCK-pie-container')
    updateViewProxy = @setUpResponsiveRender()
    console.log 'INTIALISE PIE!'
    console.log '@$vis_elem: ', @$vis_elem

  render: ->

    buckets =  @model.get('pie-data')
    values = []
    labels = []
    for bucket in buckets
      values.push bucket.doc_count
      labels.push bucket.key

    console.log 'buckets: ', buckets
    console.log 'values: ', values
    console.log 'labels: ', labels
    data1 =
      values: values
      labels: labels
      type: 'pie'
      textinfo:'none'

    data = [data1]

    width = @$vis_elem.width()
    layout =
      height: width * (2/3)
      width: width

    pieDiv = @$vis_elem.get(0)
    Plotly.newPlot pieDiv, data, layout