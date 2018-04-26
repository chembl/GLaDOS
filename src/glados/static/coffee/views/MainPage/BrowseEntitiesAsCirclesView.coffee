glados.useNameSpace 'glados.views.MainPage',
  BrowseEntitiesAsCirclesView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->
      @$vis_elem = $(@el).find('.BCK-circles-Container')
      @setUpResponsiveRender()
      @links =
        Documents: Document.getDocumentsListURL()
        Drugs: Drug.getDrugsListURL()
        Tissues: glados.models.Tissue.getTissuesListURL()
        Cells: CellLine.getCellsListURL()
        Assays: Assay.getAssaysListURL()
        Compounds: Compound.getCompoundsListURL()
        Targets: Target.getTargetsListURL()

      @render()

    render: () ->
      thisView = @
      infoURL = "#{glados.Settings.GLADOS_BASE_PATH_REL}entities_records"

      fetchDatabasePromise = $.getJSON(infoURL)

      fetchDatabasePromise.fail ->
        console.log 'Fetching entities info from web services failed :('

      fetchDatabasePromise.done (response) ->
        thisView.renderCircles(response)

    renderCircles: (data) ->
      console.log 'data: ', data
      thisView = @
      thisView.$vis_elem.empty()

      VIS_WIDTH = $(@el).width()
      VIS_HEIGHT = $(@el).height()
      PADDING = VIS_WIDTH * 0.05

      mainContainer = d3.select(@$vis_elem.get(0))
        .append('svg')
        .attr('class', 'mainSVGCirclesContainer')
        .attr('width', VIS_WIDTH)
        .attr('height', VIS_HEIGHT)

      sizes = []
      names = []
      bubbleData =
        'name': 'entities'
        'children': []

#     Get an array with the sizes
      for key, value of data
        sizes.push value
        names.push key

      min = d3.min(sizes)
      max = d3.max(sizes)

#     Scale the sizes
      sizeScale = d3.scale.sqrt()
        .range([4, 200])
        .domain([min, max])

      for key, value of data
        dataItem = {}
        dataItem.name = key
        dataItem.value = sizeScale(value)
        dataItem.count = value
        dataItem.link = thisView.links[key]

        bubbleData.children.push(dataItem)

      colour = d3.scale.ordinal()
        .domain(sizes)
        .range([
          '#FE7F9D',
          '#0d595f',
          '#8E122F',
          '#75D8D5',
          '#084044',
          '#09979B',
          '#D33C60',
        ])

#     pack layout
      diameter = Math.min(VIS_HEIGHT, VIS_WIDTH)
      pack = d3.layout.pack()
        .size([VIS_WIDTH, VIS_HEIGHT])
        .padding(PADDING)
        .sort((a, b) -> (a.value - b.value * 0.4))

      nodes = pack.nodes(bubbleData)

#     draw circles
      circles = mainContainer.selectAll('circle')
        .data(nodes)
        .enter()
        .append('circle')
          .attr('class', (d, i) -> 'node' + i )
          .attr('cx', (d) -> d.x + PADDING / 2)
          .attr('cy', (d) -> d.y + PADDING / 2)
          .attr('r', (d) -> d.r)
          .attr('fill', (d) -> colour(d.value))

      counts = mainContainer.selectAll('.count')
        .data(nodes)
        .enter()
        .append('text')
          .text((d) -> thisView.formatNumber(d.count))
          .attr('font-size', (d) -> d.r / 2)
          .attr('class', (d, i) -> 'count' + i)
          .attr('x', (d) -> d.x + PADDING / 2)
          .attr('y', (d) -> d.y + PADDING / 2)

      labels = mainContainer.selectAll('.label')
        .data(nodes)
        .enter()
        .append('text')
          .attr('font-size', (d) -> d.r / 3)
          .text((d) -> d.name)
          .attr('class', (d, i) -> 'label' + i)
          .attr('x', (d) -> d.x + PADDING / 2)
          .attr('y', (d) -> d.y + PADDING / 2 + d.r / 3)

      circlesForHover = mainContainer.selectAll('.invisible')
        .data(nodes)
        .enter()
        .append('circle')
          .attr('class', 'invisible')
          .attr('class', (d, i) -> 'hover' + i )
          .attr('cx', (d) -> d.x + PADDING / 2)
          .attr('cy', (d) -> d.y + PADDING / 2)
          .attr('r', (d) -> d.r)
          .attr('fill', 'black')
          .attr('opacity', 0)
          .on('click', (d) -> glados.Utils.URLS.shortenLinkIfTooLongAndOpen d.link )
          .on("mouseover", (d, i) ->

            ADD = PADDING/2 - 2

            d3.select('.node' + i).transition()
              .ease("cubic-out")
              .delay("10")
              .duration("200")
              .attr("r", d.r + ADD)

            d3.select('.hover' + i).transition()
              .ease("cubic-out")
              .delay("10")
              .duration("200")
              .attr("r", d.r + ADD)

            d3.select('.count' + i).transition()
              .ease("cubic-out")
              .delay("10")
              .duration("200")
              .attr('font-size', (d.r + ADD)/ 2 )

            d3.select('.label' + i).transition()
              .ease("cubic-out")
              .delay("10")
              .duration("200")
              .attr('font-size', (d.r + ADD)/ 3 )
              .attr('y', d.y + PADDING / 2 + (d.r + ADD) / 3)
          )

          .on("mouseout", (d, i) ->

            d3.select('.node' + i).transition()
              .ease("quad")
              .delay("300")
              .duration("200")
              .attr("r", d.r )

            d3.select('.hover' + i).transition()
              .ease("quad")
              .delay("300")
              .duration("200")
              .attr("r", d.r )

            d3.select('.count' + i).transition()
              .ease("quad")
              .delay("300")
              .duration("200")
              .attr('font-size', d.r/ 2 )

            d3.select('.label' + i).transition()
              .ease("quad")
              .delay("300")
              .duration("200")
              .attr('font-size', d.r/ 3)
              .attr('y', d.y + PADDING / 2 + d.r / 3)
          )

#     make first node transparent
      firstNode = d3.select('.node0')
        .style('fill', 'none')
        .style('stroke', 'none')

      firstcount = d3.select('.count0')
        .style('fill', 'none')
        .style('stroke', 'none')

      firstlabel = d3.select('.label0')
        .style('fill', 'none')
        .style('stroke', 'none')

      firstHover = d3.select('.hover0')
        .style('fill', 'none')
        .style('stroke', 'none')

    formatNumber: (number) ->
      formatted = number

      if number >= 1.0e+9
        formatted = number.toPrecision(2) / 1.0e+9 + "B"

      else if number >= 1.0e+6
        formatted = number.toPrecision(2) / 1.0e+6 + "M"

      else if number >= 1.0e+3
        formatted = number.toPrecision(2) / 1.0e+3 + "K"

      return formatted