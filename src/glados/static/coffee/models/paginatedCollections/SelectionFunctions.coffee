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

    toggleClearSelections: ->
      if not @getMeta('all_items_selected') and not @thereAreExceptions()
        @selectAll()
      else
        @unSelectAll()

    selectItem: (itemID) ->

      selectionExceptions = @getMeta('selection_exceptions')

      if !@getMeta('all_items_selected')
        selectionExceptions[itemID] = true
      else
        delete selectionExceptions[itemID]

      if Object.keys(selectionExceptions).length == @getMeta('total_records') or Object.keys(selectionExceptions).length == 0
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

      if Object.keys(exceptions).length == @getMeta('total_records')
        @selectAll()
      else
        @trigger(glados.Events.Collections.SELECTION_UPDATED, glados.Events.Collections.Params.BULK_SELECTED, idsList)

    reverseExceptions: ->

      exceptions = @getMeta('selection_exceptions')
      reversedExceptions = {}
      idProperty = @getMeta('id_column').comparator

      if @allResults?
        newItemsIDs = (model[idProperty] for model in @allResults \
          when !exceptions[model[idProperty]]?)
      else
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

      if Object.keys(exceptions).length == @getMeta('total_records')
        @unSelectAll(force=true)
      else
        @trigger(glados.Events.Collections.SELECTION_UPDATED, glados.Events.Collections.Params.BULK_UNSELECTED, idsList)

    thereAreExceptions: -> return Object.keys(@getMeta('selection_exceptions')).length > 0

    itemIsSelected: (itemID) ->

      isSelectionException = @getMeta('selection_exceptions')[itemID]?
      allAreSelected = @getMeta('all_items_selected')
      return isSelectionException != allAreSelected

    getSelectedItemsIDs: ->

      idProperty = @getMeta('id_column').comparator
      itemsList = []

      if @allResults?
        itemsList = (model[idProperty] for model in @allResults when @itemIsSelected(model[idProperty]) )
      else
        itemsList = (model.attributes[idProperty] for model in @.models when @itemIsSelected(model.attributes[idProperty]) )

      if itemsList.length != @getNumberOfSelectedItems()
        return glados.Settings.INCOMPLETE_SELECTION_LIST_LABEL

      return itemsList


    getSelectedItemsIDsPromise: ->

      selectedIDs = @getSelectedItemsIDs()

      if selectedIDs == glados.Settings.INCOMPLETE_SELECTION_LIST_LABEL
        console.log 'MAKE PROMISE'
      else
        return Promise.resolve(selectedIDs)

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

      if Object.keys(selectionExceptions).length == @getMeta('total_records') or Object.keys(selectionExceptions).length == 0
        @unSelectAll(force=true)
      else
        @trigger(glados.Events.Collections.SELECTION_UPDATED, glados.Events.Collections.Params.UNSELECTED, itemID)

    unSelectAll: (force=false) ->

      if @getNumberOfSelectedItems() > 0 or force
        @setMeta('all_items_selected', false)
        @setMeta('selection_exceptions', {})
        @trigger(glados.Events.Collections.SELECTION_UPDATED, glados.Events.Collections.Params.ALL_UNSELECTED)

    selectByPropertyValue: (propName, value) ->

      idProperty = @getMeta('id_column').comparator

      if @allResults?
        idsToSelect = (model[idProperty] for model in @allResults \
          when glados.Utils.getNestedValue(model, propName) == value)
      else
        idsToSelect = (model.attributes[idProperty] for model in @models \
          when glados.Utils.getNestedValue(model.attributes, propName) == value)

      @selectItems(idsToSelect)

    unselectByPropertyValue: (propName, value) ->

      idProperty = @getMeta('id_column').comparator

      if @allResults?
        idsToSelect = (model[idProperty] for model in @allResults \
          when glados.Utils.getNestedValue(model, propName) == value)
      else
        idsToSelect = (model.attributes[idProperty] for model in @models \
          when glados.Utils.getNestedValue(model.attributes, propName) == value)

      @unSelectItems(idsToSelect)

    getNumberOfSelectedItems: ->

      selectionExceptions = @getMeta('selection_exceptions')
      if @getMeta('all_items_selected')
        if not @thereAreExceptions()
          return @getMeta('total_records')
        else return @getMeta('total_records') - Object.keys(selectionExceptions).length

      return Object.keys(selectionExceptions).length

    selectByPropertyRange: (propName, minValue, maxValue) ->

      @unSelectAll()
      idProperty = @getMeta('id_column').comparator
      allResults = if @allResults? then @allResults else (model.attributes for model in @models)
      idsToSelect = (model[idProperty] for model in allResults \
        when minValue <= parseFloat(glados.Utils.getNestedValue(model, propName)) <= maxValue)
      @selectItems(idsToSelect)