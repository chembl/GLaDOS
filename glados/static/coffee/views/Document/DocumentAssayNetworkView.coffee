# View that renders the Document assay network section
# from the Document report card
# load CardView first!
# also make sure the html can access the handlebars templates!
DocumentAssayNetworkView = CardView.extend

  render: ->
    console.log('render!')

    assays = {
      "nodes": [
        {
          "name": "A",
          "description": "this is node a"
        },
        {
          "name": "B",
          "description": "this is node a"
        },
        {
          "name": "C",
          "description": "this is node a"
        }
      ],
      "links": [
        {
          "source": 0,
          "target": 1,
          "value": 10
        },
        {
          "source": 0,
          "target": 2,
          "value": 20
        },
        {
          "source": 1,
          "target": 2,
          "value": 30
        }
      ]
    }

    margin =
      top: 100
      right: 0
      bottom: 10
      left: 100

    width = 600
    height = 600

    svg = d3.select('#AssayNetworkVisualisationContainer').append('svg')
            .attr('width', width)
            .attr('height', height)


    matrix = []
    nodes = assays.nodes
    total = 0
    n = nodes.length

    # Compute index per node.
    nodes.forEach (node, i) ->
      node.index = i
      node.count = 0
      matrix[i] = d3.range(n).map((j) ->
        {
          x: j
          y: i
          z: 0
        }
      )

    # Convert links to matrix; count character occurrences.
    assays.links.forEach (link) ->
      matrix[link.source][link.target].z = link.value
      matrix[link.target][link.source].z = link.value
      nodes[link.source].count += link.value
      nodes[link.target].count += link.value
      total += link.value

    console.log 'Matrix:'
    console.log matrix

    max = d3.max assays.links, (d) -> d.value


