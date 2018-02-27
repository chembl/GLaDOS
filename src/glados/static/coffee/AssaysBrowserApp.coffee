class AssaysBrowserApp

  @init = ->

    filter = URLProcessor.getFilter()
    assays = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESAssaysList(filter)

    $browserContainer = $('.BCK-BrowserContainer')
    new glados.views.Browsers.BrowserMenuView
      collection: assays
      el: $browserContainer

    assays.fetch()