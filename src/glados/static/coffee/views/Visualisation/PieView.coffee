# this view is in charge of showing a collection of elements as a pie chart
PieView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->
    @$vis_elem = $(@el).find('.BCK-pie-container')
    updateViewProxy = @setUpResponsiveRender()
    console.log 'INTIALISE PIE!'
    console.log '@$vis_elem: ', @$vis_elem
  render: ->
    console.log 'RENDER PIE!'