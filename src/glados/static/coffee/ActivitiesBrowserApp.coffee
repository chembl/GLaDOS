class ActivitiesBrowserApp

  @init = ->

    filter = URLProcessor.getFilter()
    actsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESActivitiesList(filter)

    menuView = new glados.views.Browsers.BrowserMenuView
      collection: actsList
      el: $('.BCK-BrowserContainer')
      standalone_mode: true

    actsList.fetch()