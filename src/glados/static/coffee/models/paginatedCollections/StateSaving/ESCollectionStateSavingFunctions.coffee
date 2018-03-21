glados.useNameSpace 'glados.models.paginatedCollections.StateSaving',

  ESCollectionStateSavingFunctions:

    getStateJSON: ->

      console.log 'getting json state'
      pathInSettings = @getMeta('settings_path')

      queryString = @getMeta('custom_query_string')
      useQueryString = @getMeta('use_custom_query_string')

      state =
        path_in_settings: pathInSettings
        query_string: queryString
        use_query_string: useQueryString

      return state


