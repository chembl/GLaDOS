glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  BlogEntriesList:
    initURL: ->

      @baseUrl = "#{glados.Settings.GLADOS_BASE_PATH_REL}blog_entries"
      @setMeta('base_url', @baseUrl, true)
      return @baseUrl

    setDataAfterParse: (parsed) ->
      @setMeta('next_page_token', parsed.nextPageToken, true)

    getNextPageToken: ->
      nextPageToken = @getMeta('next_page_token')
      return nextPageToken




