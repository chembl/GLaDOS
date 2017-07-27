class TargetsBrowserApp

  @init = ->

    filter = URLProcessor.getFilter()
    targsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESTargetsList(filter)

    new glados.views.Browsers.BrowserMenuView
      collection: targsList
      el: $('.BCK-BrowserContainer')
      standalone_mode: true

    new glados.views.Browsers.BrowserFacetView
      collection: targsList
      standalone_mode: true

    targsList.fetch()