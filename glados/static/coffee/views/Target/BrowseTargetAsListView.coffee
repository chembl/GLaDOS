BrowseTargetAsListView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @render, @

  showPreloader: ->

    if $(@el).attr('data-loading') == 'false' or !$(@el).attr('data-loading')?
      $(@el).html Handlebars.compile($('#Handlebars-Common-Preloader').html())
      $(@el).attr('data-loading', 'true')

  hidePreloader: ->

    $(@el).find('.card-preolader-to-hide').hide()
    $(@el).attr('data-loading', 'false')

  render: ->

    console.log('start to render list ' + new Date())

    all_nodes = @model.get('all_nodes')
    table = $(@el).find('.tree')
    table.empty()

    console.log('start create list views ' + new Date())
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

    console.log('finish to create list views ' + new Date())


    console.log('start to collapse all ' + new Date())
    #table.treegrid()

    #table.treegrid('collapseAll')
    console.log('finish to collapse all ' + new Date())

    console.log('finish to render list ' + new Date())


  expandAll: ->
    @model.expandAll()

  collapseAll: ->
    @model.collapseAll()

  selectAll: ->
    @model.selectAll()

  clearSelections: ->
    @model.clearSelections()