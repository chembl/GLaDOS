class CompoundsBrowserApp

  @init = ->

    filter = URLProcessor.getFilter()
    compsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(filter)

    $browserContainer = $('.BCK-BrowserContainer')
    new glados.views.Browsers.BrowserMenuView
      collection: compsList
      el: $browserContainer
      standalone_mode: true

    new glados.views.Browsers.BrowserFacetView
      collection: compsList
      standalone_mode: true
      el: $browserContainer.find('.BCK-Facets-Container')

    compsList.fetch()

