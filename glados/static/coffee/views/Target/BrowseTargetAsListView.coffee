BrowseTargetAsListView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @render, @

  render: ->

    all_nodes = @model.get('all_nodes')
    table = $(@el).find('.tree')

    for node in all_nodes.models

      new_row = Handlebars.compile($('#Handlebars-TargetBrowser-AsList-item').html())
        id: node.get('id')
        name: node.get('name')
        size: node.get('size')
        parent_id: if node.get('parent')? then node.get('parent').get('id') else undefined

      new_elem = $(new_row)
      table.append(new_elem)

      newView = new BrowseTargetAsListNodeView
        model: node
        el: new_elem


    table.treegrid()
    table.treegrid('collapseAll')