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

    @initBrowserForEntity = (entityName, filter) ->

      initListFunction = @entityListsInitFunctions[entityName]
      compsList = initListFunction(filter)

      $browserContainer = $('.BCK-BrowserContainer')
      new glados.views.Browsers.BrowserMenuView
        collection: compsList
        el: $browserContainer

      compsList.fetch()

