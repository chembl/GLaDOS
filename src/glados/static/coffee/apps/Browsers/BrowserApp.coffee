glados.useNameSpace 'glados.apps.Browsers',
  BrowserApp: class BrowserApp

    @init =->

      router = new glados.apps.Browsers.BrowserRouter
      Backbone.history.start()

    @entityListsInitFunctions:
      compounds: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      targets: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESTargetsList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      assays: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESAssaysList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      documents: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESDocumentsList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      cells: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCellsList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      tissues: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESTissuesList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      drugs: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESDrugsList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)

    # TODO: standardise the entity names from the models
    @entityNames:
      compounds: 'Compounds'
      targets: 'Targets'
      assays: 'Assays'
      documents: 'Documents'
      cells: 'Cells'
      tissues: 'Tissues'
      drugs: 'Drugs'

    @initBrowserForEntity = (entityName, filter) ->

      $mainContainer = $('.BCK-main-container')
      $mainContainer.show()

      $browserWrapper = $mainContainer.find('.BCK-browser-wrapper')
      glados.Utils.fillContentForElement $browserWrapper,
        entity_name: @entityNames[entityName]

      initListFunction = @entityListsInitFunctions[entityName]
      list = initListFunction(filter)

      $browserContainer = $browserWrapper.find('.BCK-BrowserContainer')

      new glados.views.Browsers.BrowserMenuView
        collection: list
        el: $browserContainer

      list.fetch()

