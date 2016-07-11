BrowseTargetMainView = Backbone.View.extend

  initialize: ->

    @model.on 'change', @setParentIds, @

    @listView = TargetBrowserApp.initBrowserAsList(@model, $('#BCK-TargetBrowserAsList'))
    @circlesView = TargetBrowserApp.initBrowserAsCircles(@model, $('#BCK-TargetBrowserAsCircles'))


  setParentIds: ->

    # add the parent id to the nodes to ease the handling of the tree
    lvl_1_nodes = @model.get('children')

    setNodeParentId = (node, parent_id) ->
      node.parent_id = parent_id

      if node.children?
        for child in node.children
          setNodeParentId(child, node.id)

    for node in lvl_1_nodes
      setNodeParentId(node, undefined)

    console.log(@model)


