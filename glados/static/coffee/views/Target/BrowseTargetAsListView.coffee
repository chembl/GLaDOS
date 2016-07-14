BrowseTargetAsListView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @render, @

  render: ->

    console.log('start to render list ' + new Date())

    all_nodes = @model.get('all_nodes')
    table = $(@el).find('.tree')

    console.log('start create list views ' + new Date())
    for node in all_nodes.models

      new_row = Handlebars.compile($('#Handlebars-TargetBrowser-AsList-item').html())
        id: node.get('id')
        name: node.get('name')
        size: node.get('size')
        parent_id: if node.get('parent')? then node.get('parent').get('id') else undefined

      new_elem = $(new_row).attr('id', 'rowFor' + node.get('id'))
      table.append(new_elem)

      newView = new BrowseTargetAsListNodeView
        model: node
        el: new_elem

    console.log('finish to create list views ' + new Date())


    console.log('start to collapse all ' + new Date())
    table.treegrid()

    #table.treegrid('collapseAll')
    console.log('finish to collapse all ' + new Date())

    console.log('finish to render list ' + new Date())


  expandAll: ->
    $(@el).find('.tree').treegrid('expandAll')

  collapseAll: ->
    $(@el).find('.tree').treegrid('collapseAll')