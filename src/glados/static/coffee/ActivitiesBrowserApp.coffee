class ActivitiesBrowserApp

  @init = ->

    actsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewActivitiesList()
    $elem = $('#BCK-ActivitiesSearchResults')
    infView = glados.views.PaginatedViews.PaginatedView.getNewInfinitePaginatedView(actsList, $elem)
    actsList.fetch()
    console.log 'list: ', actsList
    console.log actsList.url