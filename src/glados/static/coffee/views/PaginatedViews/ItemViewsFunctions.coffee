glados.useNameSpace 'glados.views.PaginatedViews',
  ItemViewsFunctions:

    hasCustomElementView: -> @collection.getMeta('custom_cards_item_view')?
    createCustomItemViewsContainer: -> @customItemViewsContainer = []
    cleanUpCustomItemViewsContainer: -> @customItemViewsContainer = []
    createCustomElementView: (model, $newItemElem) ->

      CustomElementView = @collection.getMeta('custom_cards_item_view')
      new CustomElementView
        model: model
        el: $newItemElem


