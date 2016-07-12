TargetHierarchyNode = Backbone.Model.extend

  checkMeAndMyDescendants: ->

    @set('selected', true)

    for nodeModel in @get('children').models
      nodeModel.checkMeAndMyDescendants()


  unCheckMeAndMyDescendants: ->

    @set('selected', false)

    for nodeModel in @get('children').models
      nodeModel.unCheckMeAndMyDescendants()
