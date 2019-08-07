glados.useNameSpace 'glados.models.paginatedCollections.TextFilter',

  ESCollectionTextFilterFunctions:

    setTextFilter: (newFilter) ->

      @setMeta('text_filter', newFilter)

    getTextFilter: -> @getMeta('text_filter')

    clearTextFilter: -> @setMeta('text_filter', undefined)
