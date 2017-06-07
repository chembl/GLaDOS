class ActivitiesBrowserApp

  @init = ->

    filter = URLProcessor.getFilter()
    actsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESActivitiesList(filter)
    $elem = $('#BCK-ActivitiesSearchResults')
    infView = glados.views.PaginatedViews.PaginatedView.getNewInfinitePaginatedView(actsList, $elem)
    actsList.fetch()