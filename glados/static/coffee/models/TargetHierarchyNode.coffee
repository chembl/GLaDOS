TargetHierarchyNode = Backbone.Model.extend

  NODE_FOCUSED_EVT: 'node-expanded'

  checkMeAndMyDescendants: ->

    @set('selected', true)
    @set('incomplete', false)

    for nodeModel in @get('children').models
      nodeModel.checkMeAndMyDescendants()

    @verifyMyAncestryIsComplete()


  unCheckMeAndMyDescendants: ->

    @set('selected', false)

    for nodeModel in @get('children').models
      nodeModel.unCheckMeAndMyDescendants()

    @verifyMyAncestryIsComplete()

  verifyMyAncestryIsComplete: ->

    if @get('parent')?
      @get('parent').checkMeAndMyAncestryIsComplete()


  checkMeAndMyAncestryIsComplete: ->

    #check how many of my children are incomplete
    num_children_incomplete = _.filter(@get('children').models,
      (model) ->  model.get('incomplete') == true).length

    #check how many of my children are only unchecked
    num_children_unchecked = _.filter(@get('children').models,
      (model) -> !model.get('selected') == true ).length

    # If all of my children have been unchecked and none of them is incomplete, I have to unselect myself
    if num_children_unchecked == @get('children').models.length and num_children_incomplete == 0
      @set('selected', false)
      @set('incomplete', false)
    # If all my children are checked and I don't have incomplete children either,
    # I am no longer incomplete, and I check myself
    else if num_children_unchecked == 0 and num_children_incomplete == 0
       @set('incomplete', false)
       @set('selected', true)
    else
      # If I have some incomplete children, I am also incomplete
      @set('incomplete', true)
      @set('selected', false)

    # my parent, if I have one :(, also has to do this check
    if @get('parent')?
      @get('parent').checkMeAndMyAncestryIsComplete()

  collapseMeAndMyDescendants: ->

    @collapseMe()
    for nodeModel in @get('children').models
      nodeModel.collapseMeAndMyDescendants()

  expandMeAndMyDescendants: ->

    @expandMe()
    for nodeModel in @get('children').models
      nodeModel.expandMeAndMyDescendants()

  expandMe: ->

    @set('collapsed', false)
    for nodeModel in @get('children').models
      nodeModel.set('show', true)
      nodeModel.ensureMyDescendantsAreShown()

  collapseMe: ->

    @set('collapsed', true)
    for nodeModel in @get('children').models
      nodeModel.hideMeAndMyDescendants()

  hideMeAndMyDescendants: ->

    @set('show', false)
    for nodeModel in @get('children').models
      nodeModel.set('show', false)
      nodeModel.hideMeAndMyDescendants()

  # If I am expanded I make sure that all my children are shown
  ensureMyDescendantsAreShown: ->

    if !@get('collapsed')

      for nodeModel in @get('children').models
        nodeModel.set('show', true)
        nodeModel.ensureMyDescendantsAreShown()

  toggleCollapsed: ->

    if @get('collapsed') == true

      @set('collapsed', false)
      console.log('expanding ' + @get('name'))
      @expandMe()
      @trigger(TargetHierarchyNode.NODE_FOCUSED_EVT)

    else

      @set('collapsed', true)
      console.log('collapsing ' + @get('name'))
      @collapseMe()

  expandMyAncestors: ->

    parent = @get('parent')
    if parent?
      parent.expandMe()
      parent.expandMyAncestors()
