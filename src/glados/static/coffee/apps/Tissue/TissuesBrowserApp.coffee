glados.useNameSpace 'glados.apps.Tissue',
  TissuesBrowserApp: class TissuesBrowserApp

    @init = ->

      filter = URLProcessor.getFilter()
      tissuesList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESTissuesList(filter)

      $browserContainer = $('.BCK-BrowserContainer')
      new glados.views.Browsers.BrowserMenuView
        collection: tissuesList
        el: $browserContainer

      tissuesList.fetch()