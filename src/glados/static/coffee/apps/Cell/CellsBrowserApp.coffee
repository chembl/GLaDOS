glados.useNameSpace 'glados.apps.Cell',
  CellsBrowserApp: class CellsBrowserApp

    @init = ->

      filter = URLProcessor.getFilter()
      cellsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCellsList(filter)

      $browserContainer = $('.BCK-BrowserContainer')
      new glados.views.Browsers.BrowserMenuView
        collection: cellsList
        el: $browserContainer

      cellsList.fetch()