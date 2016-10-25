# Class in charge of rendering the index page of the ChEMBL web ui
class MainPageApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = ->

    @searchBarView = new SearchBarView()
    @searchBarView.render()

    LazyIFramesHelper.initLazyIFrames()

    @targetHierarchy = TargetBrowserApp.initTargetHierarchyTree()
    @drugList = new DrugList({})

    @targetBrowserView = TargetBrowserApp.initBrowserMain(@targetHierarchy, $('#BCK-TargetBrowserMain'))
    @drugBrowserTableView = DrugBrowserApp.initBrowserAsTable(@drugList, $('#BCK-DrugBrowserMain'))

    @drugList.fetch({reset: true})

    LazyIFramesHelper.loadObjectOnceOnClick($('a[href="#browse_targets"]'), @targetHierarchy)




