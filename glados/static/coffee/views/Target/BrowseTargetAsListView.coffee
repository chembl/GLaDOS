BrowseTargetAsListView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @render, @

  render: ->

    lvl_1_nodes = @model.get('children')
    table = $(@el).find('.tree')

    addOneNode = (curr_node, table, parent_id ) ->

      new_row = Handlebars.compile($('#Handlebars-TargetBrowser-AsList-item').html())
        id: curr_node.id
        name: curr_node.name
        size: curr_node.size
        parent_id: parent_id

      table.append(new_row)

      if curr_node.children?
        for child in curr_node.children
          addOneNode(child, table, curr_node.id)


    for node in lvl_1_nodes
      addOneNode(node, table, undefined)

    table.treegrid()
    table.treegrid('collapseAll')
