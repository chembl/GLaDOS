glados.useNameSpace 'glados.models.paginatedCollections.TextFilter',

  ESCollectionTextFilterFunctions:

    setTextFilter: (newFilter) ->

      if not newFilter? or newFilter == ''
        @clearTextFilter()
      else
        @setMeta('text_filter', newFilter)

      @setMeta('current_page', 1)
      @trigger(glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.STATE_OBJECT_CHANGED, @)
      @resetCache()
      @fetch()

    getTextFilter: -> @getMeta('text_filter')

    clearTextFilter: -> @setMeta('text_filter', undefined)
