class DrugsBrowserApp

  @init = ->
    console.log 'init drug browser'
    filter = URLProcessor.getFilter()
    drugsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESDrugsList(filter)

    $browserContainer = $('.BCK-BrowserContainer')
    new glados.views.Browsers.BrowserMenuView
      collection: drugsList
      el: $browserContainer

    drugsList.fetch()