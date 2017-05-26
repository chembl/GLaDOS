class ActivitiesBrowserApp

  @init = ->

    actsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewActivitiesList()
    actsList.fetch()
    console.log 'list: ', actsList