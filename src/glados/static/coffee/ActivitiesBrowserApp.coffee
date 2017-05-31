class ActivitiesBrowserApp

  @init = ->

    filter = URLProcessor.getFilter()
    actsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewActivitiesList(filter)
    $elem = $('#BCK-ActivitiesSearchResults')
    infView = glados.views.PaginatedViews.PaginatedView.getNewInfinitePaginatedView(actsList, $elem)
    actsList.fetch()
    console.log 'list: ', actsList
    console.log actsList.url