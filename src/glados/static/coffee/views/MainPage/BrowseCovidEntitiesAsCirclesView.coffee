glados.useNameSpace 'glados.views.MainPage',
  BrowseCovidEntitiesAsCirclesView: Backbone.View\
  .extend(ResponsiviseViewExt)\
  .extend(glados.views.base.TrackView).extend

    initialize: ->
      @initTracking('BrowseEntitiesAsCircles', glados.views.base.TrackView.viewTypes.VISUALISATION)
      @$vis_elem = $(@el).find('.BCK-circles-Container')
      @setUpResponsiveRender()
      @links =
        Documents: Document.getDocumentsListURL('_metadata.source.src_id:52 AND NOT document_chembl_id:CHEMBL4303081')
        Assays: Assay.getAssaysListURL('_metadata.source.src_id:52')
        Compounds: Compound.getCompoundsListURL('_metadata.compound_records.src_id:52')
        Activities: Activity.getActivitiesListURL('src_id:52')

      @render()

    render: () ->
      thisView = @


      infoURL = "#{glados.Settings.GLADOS_BASE_PATH_REL}covid_entities_records"

      fetchDatabasePromise = $.getJSON(infoURL)

      fetchDatabasePromise.fail ->
        console.log 'Fetching entities info from web services failed :('

      fetchDatabasePromise.done (response) ->
        thisView.renderCircles(response)

    renderCircles: (data) ->
      $(@el).find('.card-preolader-to-hide').hide()
      $(@el).find('.card-content').show()

      thisView = @
      thisView.$vis_elem.empty()


      VIS_WIDTH = $(@el).width()
      VIS_HEIGHT = $(@el).height()
      PADDING = 10

      mainEntitiesContainer = d3.select @$vis_elem[0]
        .append('svg')
        .attr('class', 'mainEntitiesContainer')
        .attr('width', VIS_WIDTH)
        .attr('height', VIS_HEIGHT)

      DARKEST_GREEN = '#084044'
      DARK_GREEN = '#0d595f'
      TEAL = '#09979B'
      LIGHT_TEAL = '#75D8D5'
      DARK_RED = '#8E122F'
      RED = '#D33C60'
      PINK = '#FE7F9D'

      colours = {
        Documents: LIGHT_TEAL
        Assays: RED
        Compounds: DARKEST_GREEN
        Activities: PINK
      }

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
        .range([50, 250])
        .domain([min, max])

      for key, value of data
        dataItem = {}
        dataItem.name = key
        dataItem.value = sizeScale(value)
        dataItem.count = value
        dataItem.link = thisView.links[key]
        dataItem.colour = colours[key]

        bubbleData.children.push(dataItem)

#     pack layout
      diameter = Math.min(VIS_HEIGHT, VIS_WIDTH)
      bubble = d3.layout.pack()
        .size([VIS_WIDTH, VIS_HEIGHT])
        .padding(PADDING)
        .sort((a, b) -> (a.value - b.value * 0.4))

      bubbleNodes = bubble.nodes(bubbleData)

#     draw circles
      circles = mainEntitiesContainer .selectAll('.nod')
        .data(bubbleNodes)
        .enter()
        .append('circle')
          .attr('class', (d, i) -> 'nod' + i )
          .attr('cx', (d) -> d.x + PADDING / 2)
          .attr('cy', (d) -> d.y + PADDING / 2)
          .attr('r', (d) -> d.r)
          .attr('fill', (d) -> d.colour )

      counts = mainEntitiesContainer .selectAll('.count')
        .data(bubbleNodes)
        .enter()
        .append('text')
          .text((d) -> thisView.formatNumber(d.count))
          .attr('font-size', (d) -> d.r / 2)
          .attr('class', (d, i) -> 'count' + i)
          .attr('x', (d) -> d.x + PADDING / 2)
          .attr('y', (d) -> d.y + PADDING / 2)

      labels = mainEntitiesContainer .selectAll('.lab')
        .data(bubbleNodes)
        .enter()
        .append('text')
          .attr('font-size', (d) -> d.r / 3)
          .text((d) -> d.name)
          .attr('class', (d, i) -> 'lab' + i)
          .attr('x', (d) -> d.x + PADDING / 2)
          .attr('y', (d) -> d.y + PADDING / 2 + d.r / 3)

      circlesForHover = mainEntitiesContainer.selectAll('.invisible')
        .data(bubbleNodes)
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

            d3.select(thisView.$vis_elem[0]).select('.nod' + i).transition()
              .ease("cubic-out")
              .delay("10")
              .duration("200")
              .attr("r", d.r + ADD)

            d3.select(thisView.$vis_elem[0]).select('.hover' + i).transition()
              .ease("cubic-out")
              .delay("10")
              .duration("200")
              .attr("r", d.r + ADD)

            d3.select(thisView.$vis_elem[0]).select('.count' + i).transition()
              .ease("cubic-out")
              .delay("10")
              .duration("200")
              .attr('font-size', (d.r + ADD)/ 2 )

            d3.select(thisView.$vis_elem[0]).select('.lab' + i).transition()
              .ease("cubic-out")
              .delay("10")
              .duration("200")
              .attr('font-size', (d.r + ADD)/ 3 )
              .attr('y', d.y + PADDING / 2 + (d.r + ADD) / 3)
          )

          .on("mouseout", (d, i) ->

            d3.select(thisView.$vis_elem[0]).select('.nod' + i).transition()
              .ease("quad")
              .delay("300")
              .duration("200")
              .attr("r", d.r )

            d3.select(thisView.$vis_elem[0]).select('.hover' + i).transition()
              .ease("quad")
              .delay("300")
              .duration("200")
              .attr("r", d.r )

            d3.select(thisView.$vis_elem[0]).select('.count' + i).transition()
              .ease("quad")
              .delay("300")
              .duration("200")
              .attr('font-size', d.r/ 2 )

            d3.select(thisView.$vis_elem[0]).select('.lab' + i).transition()
              .ease("quad")
              .delay("300")
              .duration("200")
              .attr('font-size', d.r/ 3)
              .attr('y', d.y + PADDING / 2 + d.r / 3)
          )

#     make first node transparent
      firstNode = d3.select(thisView.$vis_elem[0]).select('.nod0')
        .style('fill', 'none')
        .style('stroke', 'none')

      firstcount = d3.select(thisView.$vis_elem[0]).select('.count0')
        .style('fill', 'none')
        .style('stroke', 'none')

      firstlabel = d3.select(thisView.$vis_elem[0]).select('.lab0')
        .style('fill', 'none')
        .style('stroke', 'none')

      firstHover = d3.select(thisView.$vis_elem[0]).select('.hover0')
        .style('fill', 'none')
        .style('stroke', 'none')

    formatNumber: (number) ->
      formatted = number

      if number >= 1.0e+9
        formatted = number.toPrecision(2) / 1.0e+9 + "B"

      else if number >= 1.0e+6
        formatted = number.toPrecision(2) / 1.0e+6 + "M"

      else if number >= 1.0e+4
        numberFloor = Math.floor(number/1000)*1000
        formatted = numberFloor.toPrecision(2) / 1.0e+3 + "K"

      else if number >= 1.0e+3
        formatted = number.toPrecision(2) / 1.0e+3 + "K"

      return formatted