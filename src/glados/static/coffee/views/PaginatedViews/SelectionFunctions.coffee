glados.useNameSpace 'glados.views.PaginatedViews',
  SelectionFunctions:
    toggleSelectAll: ->
      @collection.toggleSelectAll()

    toggleSelectOneItem: (event) ->

      #for id structure the elem id must always be in the third position
      elemID = $(event.currentTarget).attr('id').split('-')[2]
      @collection.toggleSelectItem(elemID)

    selectionChangedHandler: (action, detail)->

      if action == glados.Events.Collections.Params.ALL_SELECTED

        $(@el).find('.BCK-toggle-select-all,.BCK-select-one-item').prop('checked', true)

      else if action == glados.Events.Collections.Params.ALL_UNSELECTED

        $(@el).find('.BCK-toggle-select-all,.BCK-select-one-item').prop('checked', false)

      else if action == glados.Events.Collections.Params.SELECTED

        endingID = detail + '-select'
        $(@el).find('[id$=' + endingID + ']').prop('checked', true)

      else if action == glados.Events.Collections.Params.UNSELECTED

        endingID = detail + '-select'
        $(@el).find('[id$=' + endingID + ']').prop('checked', false)
        $(@el).find('.BCK-toggle-select-all').prop('checked', false)

      else if action == glados.Events.Collections.Params.BULK_SELECTED

        for itemID in detail
          endingID = itemID + '-select'
          $(@el).find('[id$=' + endingID + ']').prop('checked', true)

