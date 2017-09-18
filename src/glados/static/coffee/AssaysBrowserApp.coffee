class AssaysBrowserApp

  @init = ->

    filter = URLProcessor.getFilter()
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewAssaysList(filter)
    $elem = $('#BCK-AssaysSearchResults')
    glados.views.PaginatedViews.PaginatedViewFactory.getNewInfinitePaginatedView(list, $elem)
    list.fetch()