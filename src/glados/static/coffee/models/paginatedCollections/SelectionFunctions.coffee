glados.useNameSpace 'glados.models.paginatedCollections',

  SelectionFunctions:

    toggleSelectAll: ->

      if @getMeta('all_items_selected')
        @unSelectAll()
      else
        @selectAll()

    toggleSelectItem: (itemID) ->

      if @itemIsSelected(itemID)
        @unSelectItem(itemID)
      else
        @selectItem(itemID)

    selectItem: (itemID) ->

      selectionExceptions = @getMeta('selection_exceptions')

      if !@getMeta('all_items_selected')
        selectionExceptions[itemID] = true
      else
        delete selectionExceptions[itemID]

      if Object.keys(selectionExceptions).length == @models.length or Object.keys(selectionExceptions).length == 0
        @selectAll()
      else
        @trigger(glados.Events.Collections.SELECTION_UPDATED, glados.Events.Collections.Params.SELECTED, itemID)

    selectItems: (idsList) ->

      idsListLength = idsList.length
      thresholdLength = Math.floor(@.models.length / 2) + 1

      if idsListLength == 0
        return

      @setMeta('all_items_selected', false)
      exceptions = @getMeta('selection_exceptions')
      for id in idsList
        exceptions[id] = true
      @setMeta('selection_exceptions', exceptions)

      if Object.keys(exceptions).length == @models.length
        @selectAll()
      else
        console.log 'triggering event!'
        @trigger(glados.Events.Collections.SELECTION_UPDATED, glados.Events.Collections.Params.BULK_SELECTED, idsList)

    thereAreExceptions: -> return Object.keys(@getMeta('selection_exceptions')).length > 0

    itemIsSelected: (itemID) ->

      isSelectionException = @getMeta('selection_exceptions')[itemID]?
      allAreSelected = @getMeta('all_items_selected')
      return isSelectionException != allAreSelected

    # warning: this is intended to work only when the list has all the elements in the client, not with server side lists
    getSelectedItemsIDs: ->

      idProperty = @getMeta('id_column').comparator
      return (model.attributes[idProperty] for model in @.models when @itemIsSelected(model.attributes[idProperty]) )

    selectAll: ->

      @setMeta('all_items_selected', true)
      @setMeta('selection_exceptions', {})
      @trigger(glados.Events.Collections.SELECTION_UPDATED, glados.Events.Collections.Params.ALL_SELECTED)

    unSelectItem: (itemID) ->

      selectionExceptions = @getMeta('selection_exceptions')

      if @getMeta('all_items_selected')
        selectionExceptions[itemID] = true
      else
        delete selectionExceptions[itemID]

      if Object.keys(selectionExceptions).length == @models.length or Object.keys(selectionExceptions).length == 0
        @unSelectAll()
      else
        @trigger(glados.Events.Collections.SELECTION_UPDATED, glados.Events.Collections.Params.UNSELECTED, itemID)

    unSelectAll: ->

      @setMeta('all_items_selected', false)
      @setMeta('selection_exceptions', {})
      @trigger(glados.Events.Collections.SELECTION_UPDATED, glados.Events.Collections.Params.ALL_UNSELECTED)

    selectByPropertyValue: (propName, value) ->

      idProperty = @getMeta('id_column').comparator
      idsToSelect = (model.attributes[idProperty] for model in @models \
        when glados.Utils.getNestedValue(model.attributes, propName) == value)

      @selectItems(idsToSelect)