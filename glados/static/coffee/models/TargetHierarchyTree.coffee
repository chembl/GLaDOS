TargetHierarchyTree = Backbone.Model.extend

  defaults:
    'children': new TargetHierarchyChildren
    'all_nodes': new TargetHierarchyChildren

  initialize: ->
    @on 'change', @initHierarhy, @

  initHierarhy: ->

    console.log('file loaded ' + new Date())

    # save the plain object version before doing the modifications
    plain = {}
    plain['name'] = @get('name')
    plain['children'] = @get('children')
    @set('plain', plain, {silent: true})

    all_nodes = new TargetHierarchyChildren
    children_col = new TargetHierarchyChildren

    #the root has depth 0
    @set('depth', 0, {silent: true})

    addOneNode = (node_obj, children_col, parent, parent_depth) ->

      my_depth = parent_depth + 1
      # new collection for the children of this children
      grand_children_coll = new TargetHierarchyChildren

      new_node = new TargetHierarchyNode
        name: node_obj.name
        id: node_obj.id
        parent: parent
        children: grand_children_coll
        size: node_obj.size
        depth: my_depth

      children_col.add(new_node)

      # add the reference to the new node to the all_nodes list
      all_nodes.add(new_node)

      if node_obj.children?
        for child_obj in node_obj.children
          addOneNode(child_obj, grand_children_coll, new_node, my_depth)


    for node in @.get('children')
      if node?
        addOneNode(node, children_col, undefined, 0)

    console.log('tree!')
    console.log(@)


    @set('all_nodes', all_nodes, {silent: true})
    @set('children', children_col, {silent: true})

    console.log('structures loaded!' + new Date())


