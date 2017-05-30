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
      textinfo:'value'

    data = [data1]
    width = @$vis_elem.width()
    layout =
      height: width * (2/3)
      width: width
      title: 'ChEMBL Activity types for target ' + @model.get('target_chembl_id')

    pieDiv = @$vis_elem.get(0)
    Plotly.newPlot pieDiv, data, layout

    thisView = @
    console.log 'target:'
    console.log @model.get('target_chembl_id')
    pieDiv.on('plotly_click', (eventInfo) ->
      clickedLabel = eventInfo.points[0].label
      labelFilter = 'standard_type=' + clickedLabel
      filter = 'target_chembl_id=' + thisView.model.get('target_chembl_id') + '&' + labelFilter
      window.open(Activity.getActivitiesListURL(filter))
    )