# View that renders the model data as a pie chart
# make sure google charts is loaded!
# <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
PieView = Backbone.View.extend

  initialize: ->

    # Load the Visualization API and the corechart package.
    google.charts.load('current', 'packages':['corechart'])

    $(window).resize( $.proxy(@drawPie, @) )


  drawPie: ->

    console.log('paiting!')

    if not GRAHPS_LIBS_LOADED
      setTimeout($.proxy(@drawPie,@), 1000) # check in 1 second if the libraries have been loaded
      return

    # Create the data table.
    data = new google.visualization.DataTable()
    data.addColumn 'string', 'Topping'
    data.addColumn 'number', 'Slices'
    data.addRows([
          ['Mushrooms', 3],
          ['Onions', 1],
          ['Olives', 1],
          ['Zucchini', 1],
          ['Pepperoni', 2]
        ])

    #Set chart options
    options =
      'title':'How Much Pizza I Ate Last Night'
      'height': '400px'

    # Instantiate and draw our chart, passing in some options.
    chart = new google.visualization.PieChart(document.getElementById('Bck-BioactivitySummaryChart'));
    chart.draw(data, options);


  render: ->

    @drawPie()

     # until here, all the visible content has been rendered.
    $(@el).children('.card-preolader-to-hide').hide()
    $(@el).children(':not(.card-preolader-to-hide, .card-load-error)').show()



