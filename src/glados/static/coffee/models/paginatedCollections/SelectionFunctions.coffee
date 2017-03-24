glados.useNameSpace 'glados.models.paginatedCollections',

  SelectionFunctions:

    toggleSelectAll: ->

      console.log 'collection: toogle select all!'
      if @getMeta('all_items_selected')
        @unSelectAll()
      else
        @selectAll()
      console.log '^^^'

    toggleSelectItem: (itemID) ->

      console.log 'collection: toogle select one item!'
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
        console.log 'collection: One item was selected!'

    : ->

      return Object.keys(@getMeta('selection_exceptions')).length > 0

    itemIsSelected: (itemID) ->

      isSelectionException = @getMeta('selection_exceptions')[itemID]?
      allAreSelected = @getMeta('all_items_selected')

      console.log itemID, 'is currently selected?', isSelectionException != allAreSelected
      return isSelectionException != allAreSelected

    getSelectedItemsIDs: ->

      idProperty = @getMeta('id_column').comparator
      return (model.attributes[idProperty] for model in @.models when @itemIsSelected(model.attributes[idProperty]) )

    selectAll: ->

      @setMeta('all_items_selected', true)
      @setMeta('selection_exceptions', {})
      @trigger(glados.Events.Collections.SELECTION_UPDATED, glados.Events.Collections.Params.ALL_SELECTED)
      console.log 'collection: ALL ITEMS WERE SELECTED!'

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
        console.log 'collection: One item was un selected!'

    unSelectAll: ->

      @setMeta('all_items_selected', false)
      @setMeta('selection_exceptions', {})
      @trigger(glados.Events.Collections.SELECTION_UPDATED, glados.Events.Collections.Params.ALL_UNSELECTED)
      console.log 'collection: ALL ITEMS WERE UNSELECTED!'