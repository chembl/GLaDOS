glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  BlogEntriesList:

    initURL: ->

      @baseUrl = "#{glados.Settings.GLADOS_BASE_PATH_REL}blog_entries"
      @setMeta('base_url', @baseUrl, true)
      return @baseUrl

    setDataFromResponse: (response) ->
      @setMeta('next_page_token', response.nextPageToken, true)
      entries = response.entries
      @reset(entries)

    getNextPageToken: ->
      nextPageToken = @getMeta('next_page_token')
      return nextPageToken




