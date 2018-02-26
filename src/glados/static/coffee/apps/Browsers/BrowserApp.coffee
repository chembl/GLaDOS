glados.useNameSpace 'glados.apps.Browsers',
  BrowserApp: class BrowserApp

    @init =->

      router = new glados.apps.Browsers.BrowserRouter
      Backbone.history.start()

      console.log 'INIT BROWSER APP!!!'

    @entityListsInitFunctions:
      compounds: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)

    @initBrowserForEntity = (entityName) ->

      filter = URLProcessor.getFilter()
      initListFunction = @entityListsInitFunctions[entityName]
      compsList = initListFunction(filter)

      $browserContainer = $('.BCK-BrowserContainer')
      new glados.views.Browsers.BrowserMenuView
        collection: compsList
        el: $browserContainer

      compsList.fetch()

