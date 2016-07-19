describe "Target hierarchy tree", ->
  targetTree = TargetBrowserApp.initTargetHierarchyTree()
  #make sure url is the test url
  targetTree.url = '/static/data/sample_target_tree.json'

  beforeAll (done) ->
    targetTree.fetch
      success: done

  afterEach ->
    targetTree.clearSelections()
    targetTree.resetSearch()
    targetTree.collapseAll()


  it "selects all nodes", (done) ->
    targetTree.selectAll()
    for node in targetTree.get('all_nodes').models
      expect(node.get('selected')).toBe(true)
      expect(node.get('incomplete')).toBe(false)

    done()

  it "clears all selections", (done) ->
    targetTree.clearSelections()
    for node in targetTree.get('all_nodes').models
      expect(node.get('selected')).toBe(false)
      expect(node.get('incomplete')).toBe(false)

    done()

  it "collapses all nodes", (done) ->
    targetTree.collapseAll()
    for node in targetTree.get('all_nodes').models
      expect(node.get('collapsed')).toBe(true)

    done()

  it "expands all nodes", (done) ->
    targetTree.expandAll()
    for node in targetTree.get('all_nodes').models
      expect(node.get('collapsed')).toBe(false)

    done()

  it "selects a node and its children", (done) ->
    nodes_dict = targetTree.get('all_nodes_dict')

    enzyme_node = nodes_dict['1']
    enzyme_node.checkMeAndMyDescendants()

    all_nodes = targetTree.get('all_nodes').models

    selected_ids_str = getSelectedNodesListStr()
    unselected_ids_str = getUnSelectedNodesListStr()


    expect(selected_ids_str).toBe('1,2,3,4,5,6,7')
    expect(unselected_ids_str).toBe('10,11,12,8,9')

    done()


  it "unselects a node and its children", (done) ->

    targetTree.selectAll()

    enzyme_node = getNodeFromID('1')
    enzyme_node.unCheckMeAndMyDescendants()

    selected_ids_str = getSelectedNodesListStr()
    unselected_ids_str = getUnSelectedNodesListStr()


    expect(selected_ids_str).toBe('10,11,12,8,9')
    expect(unselected_ids_str).toBe('1,2,3,4,5,6,7')

    done()

  it "marks parent nodes as incomplete", (done) ->

    metallo_node = getNodeFromID('7')
    metallo_node.checkMeAndMyDescendants()

    all_nodes = targetTree.get('all_nodes').models

    selected_nodes = getSelectedNodesListStr()
    incomplete_nodes = getIncompleteNodesListStr()
    unselected_nodes = getUnSelectedNodesListStr()

    expect(selected_nodes).toBe('7')
    expect(incomplete_nodes).toBe('1,5')
    expect(unselected_nodes).toBe('1,10,11,12,2,3,4,5,6,8,9')

    done()

  it "selects a node when all its children are selected", (done) ->

    metallo_node = getNodeFromID('7')
    serine_node = getNodeFromID('6')

    metallo_node.checkMeAndMyDescendants()
    serine_node.checkMeAndMyDescendants()

    selected_nodes = getSelectedNodesListStr()
    incomplete_nodes = getIncompleteNodesListStr()
    unselected_nodes = getUnSelectedNodesListStr()

    expect(selected_nodes).toBe('5,6,7')
    expect(incomplete_nodes).toBe('1')
    expect(unselected_nodes).toBe('1,10,11,12,2,3,4,8,9')

    done()

  it "selects and marks as incomplete nodes when an intermediate node is selected", (done) ->

    kinase_node = getNodeFromID('2')

    kinase_node.checkMeAndMyDescendants()

    selected_nodes = getSelectedNodesListStr()
    incomplete_nodes = getIncompleteNodesListStr()
    unselected_nodes = getUnSelectedNodesListStr()

    expect(selected_nodes).toBe('2,3,4')
    expect(incomplete_nodes).toBe('1')
    expect(unselected_nodes).toBe('1,10,11,12,5,6,7,8,9')

    done()

  it "expands all nodes", (done) ->

    targetTree.expandAll()

    expanded_nodes = getExpandedNodesListStr()
    expect(expanded_nodes).toBe('1,10,11,12,2,3,4,5,6,7,8,9')

    done()

  it "collapses all nodes", (done) ->

    targetTree.expandAll()
    targetTree.collapseAll()

    collapsed_nodes = getCollapsedNodesListStr()
    expect(collapsed_nodes).toBe('1,10,11,12,2,3,4,5,6,7,8,9')

    done()

  it "shows the correct nodes when one is expanded", (done) ->

    enzyme_node = getNodeFromID('1')

    enzyme_node.expandMe()

    shown_nodes = getShownNodesListStr()
    hidden_nodes = getHiddenNodesListStr()

    expect(shown_nodes).toBe('1,10,2,5,8')
    expect(hidden_nodes).toBe('11,12,3,4,6,7,9')

    done()

  it "remembers which nodes were expanded", (done) ->

    enzyme_node = getNodeFromID('1')
    kinase_node = getNodeFromID('2')

    enzyme_node.expandMe()
    kinase_node.expandMe()
    enzyme_node.collapseMe()
    enzyme_node.expandMe()

    shown_nodes = getShownNodesListStr()
    hidden_nodes = getHiddenNodesListStr()

    expect(shown_nodes).toBe('1,10,2,3,4,5,8')
    expect(hidden_nodes).toBe('11,12,6,7,9')

    done()

  it "searches for a node", (done) ->

    targetTree.searchInTree('Kinase')

    shown_nodes = getShownNodesListStr()
    found_nodes = getFoundNodesListStr()

    expect(shown_nodes).toBe('1,10,2,3,4,5,8')
    expect(found_nodes).toBe('2,3,4')


    done()

  it "resets a search", (done) ->

    targetTree.searchInTree('Kinase')
    targetTree.resetSearch()

    shown_nodes = getShownNodesListStr()
    found_nodes = getFoundNodesListStr()

    expect(shown_nodes).toBe('1,10,8')
    expect(found_nodes).toBe('')

    done()




  # ------------------------------
  # Helpers
  # ------------------------------

  getSelectedNodesListStr = () ->

    all_nodes = targetTree.get('all_nodes').models

    return _.map(_.filter(all_nodes, (model) ->
      model.get('selected') and !model.get('incomplete')),
      (selected) ->selected.get('id')).sort().toString()

  getUnSelectedNodesListStr = () ->

    all_nodes = targetTree.get('all_nodes').models

    return _.map(_.filter(all_nodes, (model) ->
      !model.get('selected')),
      (selected) ->selected.get('id')).sort().toString()

  getNodeFromID = (id) ->

    return targetTree.get('all_nodes_dict')[id]

  getIncompleteNodesListStr = () ->

    all_nodes = targetTree.get('all_nodes').models

    return _.map(_.filter(all_nodes, (model) ->
      model.get('incomplete') ),
      (selected) -> selected.get('id')).sort().toString()

  getCollapsedNodesListStr = () ->

    all_nodes = targetTree.get('all_nodes').models

    return _.map(_.filter(all_nodes, (model) ->
      model.get('collapsed')),
      (selected) ->selected.get('id')).sort().toString()

  getExpandedNodesListStr = () ->

    all_nodes = targetTree.get('all_nodes').models

    return _.map(_.filter(all_nodes, (model) ->
      !model.get('collapsed')),
      (selected) ->selected.get('id')).sort().toString()

  getShownNodesListStr = () ->

    all_nodes = targetTree.get('all_nodes').models

    return _.map(_.filter(all_nodes, (model) ->
      model.get('show')),
      (selected) ->selected.get('id')).sort().toString()

  getHiddenNodesListStr = () ->

    all_nodes = targetTree.get('all_nodes').models

    return _.map(_.filter(all_nodes, (model) ->
      !model.get('show')),
      (selected) ->selected.get('id')).sort().toString()

  getFoundNodesListStr = () ->

    all_nodes = targetTree.get('all_nodes').models

    return _.map(_.filter(all_nodes, (model) ->
      model.get('found')),
      (selected) ->selected.get('id')).sort().toString()

