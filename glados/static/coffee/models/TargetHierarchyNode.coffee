TargetHierarchyNode = Backbone.Model.extend

  checkMeAndMyDescendants: ->

    @set('selected', true)
    @set('incomplete', false)

    for nodeModel in @get('children').models
      nodeModel.checkMeAndMyDescendants()


  unCheckMeAndMyDescendants: ->

    @set('selected', false)

    for nodeModel in @get('children').models
      nodeModel.unCheckMeAndMyDescendants()

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







