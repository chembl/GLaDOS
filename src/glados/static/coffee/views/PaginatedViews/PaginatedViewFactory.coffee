glados.useNameSpace 'glados.views.PaginatedViews',
  PaginatedViewFactory:
    CARDS_TYPE: 'CARDS_TYPE'
    CAROUSEL_TYPE: 'CAROUSEL_TYPE'
    INFINITE_TYPE: 'INFINITE_TYPE'
    TABLE_TYPE: 'TABLE_TYPE'

glados.views.PaginatedViews.PaginatedViewFactory.Cards = glados.views.PaginatedViews.PaginatedViewBase\
  .extend(glados.views.PaginatedViews.DeferredViewsFunctions)\
  .extend(glados.views.PaginatedViews.CardZoomFunctions)\
  .extend(glados.views.PaginatedViews.ItemViewsFunctions)\
  .extend(glados.views.PaginatedViews.PaginationFunctions)

glados.views.PaginatedViews.PaginatedViewFactory.Carousel = glados.views.PaginatedViews.PaginatedViewBase\
  .extend(glados.views.PaginatedViews.DeferredViewsFunctions)\
  .extend(glados.views.PaginatedViews.CardZoomFunctions)\
  .extend(glados.views.PaginatedViews.ItemViewsFunctions)\
  .extend(glados.views.PaginatedViews.PaginationFunctions)

glados.views.PaginatedViews.PaginatedViewFactory.Infinite = glados.views.PaginatedViews.PaginatedViewBase\
  .extend(glados.views.PaginatedViews.DeferredViewsFunctions)\
  .extend(glados.views.PaginatedViews.CardZoomFunctions)\
  .extend(glados.views.PaginatedViews.ItemViewsFunctions)\
  .extend(glados.views.PaginatedViews.PaginationFunctions)

glados.views.PaginatedViews.PaginatedViewFactory.Table = glados.views.PaginatedViews.PaginatedViewBase\
  .extend(glados.views.PaginatedViews.DeferredViewsFunctions)\
  .extend(glados.views.PaginatedViews.CardZoomFunctions)\
  .extend(glados.views.PaginatedViews.ItemViewsFunctions)\
  .extend(glados.views.PaginatedViews.PaginationFunctions)

glados.views.PaginatedViews.PaginatedViewFactory.getNewCardsPaginatedView = (collection, el, customRenderEvents)->

  View = glados.views.PaginatedViews.PaginatedViewFactory.Cards

  return new View
    collection: collection
    el: el
    type: glados.views.PaginatedViews.PaginatedViewFactory.CARDS_TYPE
    custom_render_evts: customRenderEvents

glados.views.PaginatedViews.PaginatedViewFactory.getNewCardsCarouselView = (collection, el, customRenderEvents)->

  View = glados.views.PaginatedViews.PaginatedViewFactory.Carousel

  return new View
    collection: collection
    el: el
    type: glados.views.PaginatedViews.PaginatedViewFactory.CAROUSEL_TYPE
    custom_render_evts: customRenderEvents

glados.views.PaginatedViews.PaginatedViewFactory.getNewInfinitePaginatedView = (collection, el, customRenderEvents)->

  View = glados.views.PaginatedViews.PaginatedViewFactory.Infinite

  return new View
    collection: collection
    el: el
    type: glados.views.PaginatedViews.PaginatedViewFactory.INFINITE_TYPE
    custom_render_evts: customRenderEvents

glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView = (collection, el, customRenderEvents,
  disableColumnsSelection=false, disableItemSelection=true)->

  View = glados.views.PaginatedViews.PaginatedViewFactory.Table

  return new View
    collection: collection
    el: el
    type: glados.views.PaginatedViews.PaginatedViewFactory.TABLE_TYPE
    custom_render_evts: customRenderEvents
    disable_columns_selection: disableColumnsSelection
    disable_items_selection: disableItemSelection


glados.views.PaginatedViews.PaginatedViewFactory.getTypeConstructor = (pagViewType)->
  viewClass = undefined
  if pagViewType == glados.views.PaginatedViews.PaginatedViewFactory.CARDS_TYPE
    viewClass = glados.views.PaginatedViews.PaginatedViewFactory.Cards
  else if pagViewType == glados.views.PaginatedViews.PaginatedViewFactory.TABLE_TYPE
    viewClass = glados.views.PaginatedViews.PaginatedViewFactory.Table
  else if pagViewType == glados.views.PaginatedViews.PaginatedViewFactory.INFINITE_TYPE
    viewClass = glados.views.PaginatedViews.PaginatedViewFactory.Infinite

  tmp_constructor = ->
    arguments[0].type = pagViewType
    viewClass.apply(@, arguments)

  tmp_constructor.prototype = viewClass.prototype

  return tmp_constructor

glados.views.PaginatedViews.PaginatedViewFactory.getCardsConstructor = ()->
  return glados.views.PaginatedViews.PaginatedViewFactory\
    .getTypeConstructor(glados.views.PaginatedViews.PaginatedViewFactory.CARDS_TYPE)

glados.views.PaginatedViews.PaginatedViewFactory.getTableConstructor = ()->
  return glados.views.PaginatedViews.PaginatedViewFactory\
    .getTypeConstructor(glados.views.PaginatedViews.PaginatedViewFactory.TABLE_TYPE)

glados.views.PaginatedViews.PaginatedViewFactory.getInfiniteConstructor = ()->
  return glados.views.PaginatedViews.PaginatedViewFactory\
    .getTypeConstructor(glados.views.PaginatedViews.PaginatedViewFactory.INFINITE_TYPE)
