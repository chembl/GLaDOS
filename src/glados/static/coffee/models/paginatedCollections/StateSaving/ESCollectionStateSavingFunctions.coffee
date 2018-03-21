glados.useNameSpace 'glados.models.paginatedCollections.StateSaving',

  ESCollectionStateSavingFunctions:

    # Keep in mind that the state object needs to ALWAYS be serializable, because it will be included in urls and
    # transferred externally
    getStateJSON: ->

      pathInSettings = @getMeta('settings_path')

      queryString = @getMeta('custom_query_string')
      useQueryString = @getMeta('use_custom_query_string')

      state =
        path_in_settings: pathInSettings
        query_string: queryString
        use_query_string: useQueryString

      return state


