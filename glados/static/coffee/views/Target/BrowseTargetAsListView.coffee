BrowseTargetAsListView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @render, @

  showPreloader: ->

    $(@el).find('.preloader-container').show()

    table = $(@el).find('.tree')
    table.hide()

  hidePreloader: ->


    $(@el).find('.preloader-container').hide()

    table = $(@el).find('.tree')
    table.show()


  render: ->


    # we assume that 30% is getting the data from the server
    @setPreloaderWidth('30%')

    all_nodes = @model.get('all_nodes')
    table = $(@el).find('.tree')
    table.empty()

    counter = 0
    num_nodes = all_nodes.models.length

    for node in all_nodes.models

      indentator = [1..node.get('depth')]
      indentator.pop()


      new_row = Handlebars.compile($('#Handlebars-TargetBrowser-AsList-item').html())
        id: node.get('id')
        name: node.get('name')
        size: node.get('size')
        # this is because handlebars doesn't have simple for loops
        indent: indentator
        is_leaf: node.get('is_leaf')

      new_elem = $(new_row).attr('id', 'rowFor' + node.get('id'))
      table.append(new_elem)

      if node.get('show') == true
          new_elem.show()
      else
        new_elem.hide()

      newView = new BrowseTargetAsListNodeView
        model: node
        el: new_elem

      counter++
      percentage = Math.round((counter / num_nodes) * 100)
      if percentage % 30 == 0
        #percentage is minimum 30%
        percentage_toShow = (percentage * 0.7) + 30
        @setPreloaderWidth(percentage_toShow + '%')



    @hidePreloader()


  expandAll: ->
    @model.expandAll()

  collapseAll: ->
    @model.collapseAll()

  selectAll: ->
    @model.selectAll()

  clearSelections: ->
    @model.clearSelections()

  setPreloaderWidth: (width) ->

    bar = $(@el).find('.preloader-container').find('.determinate')
    bar.attr('style', 'width:' + width)
    console.log(bar.css('width'))
