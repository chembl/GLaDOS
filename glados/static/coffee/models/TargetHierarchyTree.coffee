TargetHierarchyTree = Backbone.Model.extend

  initialize: ->
    @.on 'change', @initHierarhy, @

  initHierarhy: ->

    children_col = new TargetHierarchyChildren

    addOneNode = (node_obj, children_col, parent_id) ->

      # new collection for the children of this children
      grand_children_coll = new TargetHierarchyChildren

      node = new TargetHierarchyNode
        name: node_obj.name
        id: node_obj.id
        parent_id: parent_id
        children: grand_children_coll
        size: node_obj.size

      children_col.add(node)

      if node_obj.children?
        for child_obj in node_obj.children
          addOneNode(child_obj, grand_children_coll, node_obj.id)


    for node in @.get('children')
      addOneNode(node, children_col, undefined)

