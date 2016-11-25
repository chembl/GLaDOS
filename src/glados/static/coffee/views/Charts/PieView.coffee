# View that renders the model data as a pie chart
# make sure google charts is loaded!
# <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
PieView = Backbone.View.extend

  initialize: ->


  drawPie: ->

    data =
      labels: ['Bananas', 'Apples', 'Grapes']
      series: [ 20, 15, 40 ]

    # Create a new line chart object where as first parameter we pass in a selector
    # that is resolving to our chart container element. The Second parameter
    # is the actual data object.
    new (Chartist.Pie)('#Bck-BioactivitySummaryChart', data)


  render: ->

    @drawPie()

     # until here, all the visible content has been rendered.
    $(@el).children('.card-preolader-to-hide').hide()
    $(@el).children(':not(.card-preolader-to-hide, .card-load-error)').show()



