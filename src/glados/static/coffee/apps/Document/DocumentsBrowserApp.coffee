glados.useNameSpace 'glados.apps.Document',
  DocumentsBrowserApp: class DocumentsBrowserApp

    @init = ->

      filter = URLProcessor.getFilter()
      docsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESDocumentsList(filter)

      $browserContainer = $('.BCK-BrowserContainer')
      new glados.views.Browsers.BrowserMenuView
        collection: docsList
        el: $browserContainer

      docsList.fetch()