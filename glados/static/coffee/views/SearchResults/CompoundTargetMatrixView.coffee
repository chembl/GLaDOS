# this view is in charge of showing the compound vs target matrix
CompoundTargetMatrixView = Backbone.View.extend(ResponsiviseViewExt).extend

  initialize: ->

    @$vis_elem = $('#BCK-CompTargMatrixContainer')
    updateViewProxy = @setUpResponsiveRender()


  render: ->

    console.log 'render!'

    @paintMatrix()
    @hidePreloader()

  paintMatrix: ->

    console.log 'painting matrix'

    # --------------------------------------
    # Data
    # --------------------------------------

    compsTargets = {
      "rows": [
        {
          "name": "C1",
        },
        {
          "name": "C2",
        },
        {
          "name": "C3",
        }
      ],
      "columns": [
        {
          "name": "T1",
        },
        {
          "name": "T2",
        },
        {
          "name": "T3",
        },
        {
          "name": "T4",
        },
      ],
      "links": {

        #source Target
        0: {
          # destination Compound
          0: 1 # this means target 0 is connected to compound 0
          1: 0 # target 0 is NOT connected to compound 1
          2: 1
        }
        1: {
          0: 0
          1: 1
          2: 0
        }
        2: {
          0: 1
          1: 0
          2: 0
        }
        4: {
          0: 0
          1: 0
          2: 0
        }


      }

    }

    # --------------------------------------
    # pre-configuration
    # --------------------------------------

    margin =
      top: 70
      right: 0
      bottom: 10
      left: 90

    elemWidth = $(@el).width()
    height = width = 0.8 * elemWidth

    getXCoord = d3.scale.ordinal().rangeBands([0, width])

    svg = d3.select('#' + @$vis_elem.attr('id'))
            .append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    # background rectangle
    svg.append("rect")
      .attr("class", "background")
      .style("fill", "white")
      .attr("width", width)
      .attr("height", height)

    # --------------------------------------
    # Work with data
    # --------------------------------------
    matrix = []
    rows = compsTargets.rows
    columns = compsTargets.columns

    # compute indices of matrix as list of lists
    columns.forEach (node, i) ->
      node.index = i
      matrix[i] = d3.range(rows.length).map((j) ->
        {
          col: j
          row: i
          z: compsTargets.links[i][j]
        }
      )

    console.log 'Matrix:'
    console.log matrix
