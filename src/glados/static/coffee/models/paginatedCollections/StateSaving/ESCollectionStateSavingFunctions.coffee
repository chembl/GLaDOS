glados.useNameSpace 'glados.models.paginatedCollections.StateSaving',

  ESCollectionStateSavingFunctions:

    getStateJSON: ->

      queryString = @getMeta('custom_query_string')
      useQueryString = @getMeta('use_custom_query_string')


