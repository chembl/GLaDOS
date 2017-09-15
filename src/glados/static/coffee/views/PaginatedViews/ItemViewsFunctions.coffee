glados.useNameSpace 'glados.views.PaginatedViews',
  ItemViewsFunctions:

    hasCustomElementView: -> @collection.getMeta('custom_cards_item_view')?
    createCustomItemViewsContainer: -> @customItemViewsContainer = []
    cleanUpCustomItemViewsContainer: -> @customItemViewsContainer = []
    createCustomElementView: (model, $newItemElem) ->

      CustomElementView = @collection.getMeta('custom_cards_item_view')
      newView = new CustomElementView
        model: model
        el: $newItemElem

      @customItemViewsContainer.push newView

    sleepCustomElementviews: ->

      for view in @customItemViewsContainer

        view.sleep() unless not view.sleep?


