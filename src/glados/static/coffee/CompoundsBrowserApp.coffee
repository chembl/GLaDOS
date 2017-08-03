class CompoundsBrowserApp

  @init = ->

    filter = URLProcessor.getFilter()
    compsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(filter)

    $browserContainer = $('.BCK-BrowserContainer')
    new glados.views.Browsers.BrowserMenuView
      collection: compsList
      el: $browserContainer

    compsList.fetch()

