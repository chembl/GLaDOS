TargetHierarchyTree = Backbone.Model.extend

  defaults:
    'children': new TargetHierarchyChildren
    'all_nodes': new TargetHierarchyChildren

  initialize: ->
    @on 'change', @initHierarchy, @

  initHierarchy: ->

    # save the plain object version before doing the modifications
    plain = {}
    plain['name'] = @get('name')
    plain['children'] = @get('children')
    @set('plain', plain, {silent: true})

    all_nodes = new TargetHierarchyChildren
    children_col = new TargetHierarchyChildren
    all_nodes_dict = {}

    #the root has depth 0
    @set('depth', 0, {silent: true})

    treeBCK = @
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
        is_leaf: node_obj.children.length == 0
        selected: false
        # add a reference to the original tree
        tree: treeBCK

      children_col.add(new_node)

      # add the reference to the new node to the all_nodes list and the dictionary
      all_nodes.add(new_node)
      all_nodes_dict[node_obj.id.toString()] = new_node

      if node_obj.children?
        for child_obj in node_obj.children
          addOneNode(child_obj, grand_children_coll, new_node, my_depth)

    for node in @.get('children')
      if node?
        addOneNode(node, children_col, undefined, 0)


    @set('all_nodes_dict', all_nodes_dict, {silent: true})
    @set('all_nodes', all_nodes, {silent: true})
    @set('children', children_col, {silent: true})

    for child in @get('children').models
      child.set('show', true, {silent: true})
      child.set('collapsed', true, {silent: true})
    @collapseAll()

    @currentLevel = 0

  collapseAll: ->

    for child in @get('children').models
      child.collapseMeAndMyDescendants()

  expandAll: ->

    for child in @get('children').models
      child.expandMeAndMyDescendants()

  selectAll: ->

    for node in @get('all_nodes').models
      node.set('selected', true)
      node.set('incomplete', false)

  clearSelections: ->

    for node in @get('all_nodes').models
      node.set('selected', false)
      node.set('incomplete', false)

  searchInTree: (terms) ->

    @collapseAll()

    termsUpper = terms.toUpperCase()
    numFound = 0

    for node in @get('all_nodes').models
      node.set('found', false)

      if node.get('name').toUpperCase().indexOf(termsUpper) != -1
        node.set('found', true)
        node.expandMyAncestors()
        numFound++

    return numFound


  resetSearch: ->

    for node in @get('all_nodes').models
      node.set('found', false)

    @collapseAll()

  unFocusAll: ->

    for node in @get('all_nodes').models
      node.set('focused', false)


