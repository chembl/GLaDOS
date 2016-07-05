class TargetBrowserApp

  ### *
    * Initializes a target hierarchy tree
    * return {TargetHierarchyTree}
  ###
  @initTargetHierarchyTree = ->
    targetTree = new TargetHierarchyTree

    # TODO: set up the correct url

    return targetTree


  # This initialises the view of the tree as a list
  @initBrowserAsList = (model, top_level_elem) ->

    asListView = new BrowseTargetAsListView
      model: model
      el: top_level_elem

    return asListView