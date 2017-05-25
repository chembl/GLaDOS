# this view is in charge of showing a collection of elements as a pie chart
PieView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->
    @$vis_elem = $(@el).find('.BCK-pie-container')
    updateViewProxy = @setUpResponsiveRender()
    console.log 'INTIALISE PIE!'
    console.log '@$vis_elem: ', @$vis_elem
  render: ->

    data1 =
      values: [19, 26, 55]
      labels: ['Residential', 'Non-Residential', 'Utility']
      type: 'pie'

    data = [data1]

    width = @$vis_elem.width()
    layout =
      height: width * (2/3)
      width: width

    pieDiv = @$vis_elem.get(0)
    Plotly.newPlot pieDiv, data, layout