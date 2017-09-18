glados.useNameSpace 'glados.views.PaginatedViews',
  PaginatedView:
    CARDS_TYPE: 'CARDS_TYPE'
    CAROUSEL_TYPE: 'CAROUSEL_TYPE'
    INFINITE_TYPE: 'INFINITE_TYPE'
    TABLE_TYPE: 'TABLE_TYPE'

glados.views.PaginatedViews.PaginatedView.Cards = glados.views.PaginatedViews.PaginatedViewBase\
  .extend(glados.views.PaginatedViews.DeferredViewsFunctions)\
  .extend(glados.views.PaginatedViews.CardZoomFunctions)\
  .extend(glados.views.PaginatedViews.ItemViewsFunctions)\
  .extend(glados.views.PaginatedViews.PaginationFunctions)

glados.views.PaginatedViews.PaginatedView.Carousel = glados.views.PaginatedViews.PaginatedViewBase\
  .extend(glados.views.PaginatedViews.DeferredViewsFunctions)\
  .extend(glados.views.PaginatedViews.CardZoomFunctions)\
  .extend(glados.views.PaginatedViews.ItemViewsFunctions)\
  .extend(glados.views.PaginatedViews.PaginationFunctions)

glados.views.PaginatedViews.PaginatedView.Infinite = glados.views.PaginatedViews.PaginatedViewBase\
  .extend(glados.views.PaginatedViews.DeferredViewsFunctions)\
  .extend(glados.views.PaginatedViews.CardZoomFunctions)\
  .extend(glados.views.PaginatedViews.ItemViewsFunctions)\
  .extend(glados.views.PaginatedViews.PaginationFunctions)

glados.views.PaginatedViews.PaginatedView.Table = glados.views.PaginatedViews.PaginatedViewBase\
  .extend(glados.views.PaginatedViews.DeferredViewsFunctions)\
  .extend(glados.views.PaginatedViews.CardZoomFunctions)\
  .extend(glados.views.PaginatedViews.ItemViewsFunctions)\
  .extend(glados.views.PaginatedViews.PaginationFunctions)

glados.views.PaginatedViews.PaginatedView.getNewCardsPaginatedView = (collection, el, customRenderEvents)->

  View = glados.views.PaginatedViews.PaginatedView.Cards

  return new View
    collection: collection
    el: el
    type: glados.views.PaginatedViews.PaginatedView.CARDS_TYPE
    custom_render_evts: customRenderEvents

glados.views.PaginatedViews.PaginatedView.getNewCardsCarouselView = (collection, el, customRenderEvents)->

  View = glados.views.PaginatedViews.PaginatedView.Carousel

  return new View
    collection: collection
    el: el
    type: glados.views.PaginatedViews.PaginatedView.CAROUSEL_TYPE
    custom_render_evts: customRenderEvents

glados.views.PaginatedViews.PaginatedView.getNewInfinitePaginatedView = (collection, el, customRenderEvents)->

  View = glados.views.PaginatedViews.PaginatedView.Infinite

  return new View
    collection: collection
    el: el
    type: glados.views.PaginatedViews.PaginatedView.INFINITE_TYPE
    custom_render_evts: customRenderEvents

glados.views.PaginatedViews.PaginatedView.getNewTablePaginatedView = (collection, el, customRenderEvents,
  disableColumnsSelection=false, disableItemSelection=true)->

  View = glados.views.PaginatedViews.PaginatedView.Table

  return new View
    collection: collection
    el: el
    type: glados.views.PaginatedViews.PaginatedView.TABLE_TYPE
    custom_render_evts: customRenderEvents
    disable_columns_selection: disableColumnsSelection
    disable_items_selection: disableItemSelection


glados.views.PaginatedViews.PaginatedView.getTypeConstructor = (pagViewType)->
  viewClass = undefined
  if pagViewType == glados.views.PaginatedViews.PaginatedView.CARDS_TYPE
    viewClass = glados.views.PaginatedViews.PaginatedView.Cards
  else if pagViewType == glados.views.PaginatedViews.PaginatedView.TABLE_TYPE
    viewClass = glados.views.PaginatedViews.PaginatedView.Table
  else if pagViewType == glados.views.PaginatedViews.PaginatedView.INFINITE_TYPE
    viewClass = glados.views.PaginatedViews.PaginatedView.Infinite

  tmp_constructor = ->
    arguments[0].type = pagViewType
    viewClass.apply(@, arguments)

  tmp_constructor.prototype = viewClass.prototype

  return tmp_constructor

glados.views.PaginatedViews.PaginatedView.getCardsConstructor = ()->
  return glados.views.PaginatedViews.PaginatedView\
    .getTypeConstructor(glados.views.PaginatedViews.PaginatedView.CARDS_TYPE)

glados.views.PaginatedViews.PaginatedView.getTableConstructor = ()->
  return glados.views.PaginatedViews.PaginatedView\
    .getTypeConstructor(glados.views.PaginatedViews.PaginatedView.TABLE_TYPE)

glados.views.PaginatedViews.PaginatedView.getInfiniteConstructor = ()->
  return glados.views.PaginatedViews.PaginatedView\
    .getTypeConstructor(glados.views.PaginatedViews.PaginatedView.INFINITE_TYPE)
