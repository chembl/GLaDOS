class ActivitiesBrowserApp

  @init = ->

    actsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugList()
    console.log 'list: ', actsList