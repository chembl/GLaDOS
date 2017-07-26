class CompoundsBrowserApp

  @init = ->

    filter = URLProcessor.getFilter()
    compsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(filter)

    new glados.views.Browsers.BrowserMenuView
      collection: compsList
      el: $('.BCK-BrowserContainer')
      standalone_mode: true

    new glados.views.Browsers.BrowserFacetView
      collection: compsList
      standalone_mode: true

    compsList.fetch()

