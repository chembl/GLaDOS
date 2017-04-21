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

    selectItems: (idsList, ignorePreviousSelections=false) ->

      idsListLength = idsList.length

      if idsListLength == 0
        return

      if @getMeta('all_items_selected')
        if not @thereAreExceptions()
          return
        else @reverseExceptions()

      @setMeta('all_items_selected', false)
      exceptions = @getMeta('selection_exceptions')

      for id in idsList
        exceptions[id] = true
      @setMeta('selection_exceptions', exceptions)

      if Object.keys(exceptions).length == @models.length
        @selectAll()
      else
        @trigger(glados.Events.Collections.SELECTION_UPDATED, glados.Events.Collections.Params.BULK_SELECTED, idsList)

    reverseExceptions: ->

      exceptions = @getMeta('selection_exceptions')
      reversedExceptions = {}
      idProperty = @getMeta('id_column').comparator
      newItemsIDs = (model.attributes[idProperty] for model in @models \
        when !exceptions[model.attributes[idProperty]]?)
      for itemID in newItemsIDs
        reversedExceptions[itemID] = true

      @setMeta('selection_exceptions', reversedExceptions)

    unSelectItems: (idsList, ignorePreviousSelections=false) ->

      idsListLength = idsList.length

      if idsListLength == 0
        return

      if not @getMeta('all_items_selected')
        if not @thereAreExceptions()
          return
        else @reverseExceptions()

      @setMeta('all_items_selected', true)
      exceptions = @getMeta('selection_exceptions')
      for id in idsList
        exceptions[id] = true
      @setMeta('selection_exceptions', exceptions)

      if Object.keys(exceptions).length == @models.length
        @unSelectAll()
      else
        @trigger(glados.Events.Collections.SELECTION_UPDATED, glados.Events.Collections.Params.BULK_UNSELECTED, idsList)

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

    getNumberOfSelectedItems: ->

      selectionExceptions = @getMeta('selection_exceptions')
      console.log 'selection exceptions:', selectionExceptions
      if @getMeta('all_items_selected')
        if not @thereAreExceptions()
          return @models.length
        else return @models.length - Object.keys(selectionExceptions).length

      return Object.keys(selectionExceptions).length