glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  BlogEntriesList:

    initURL: ->

      @baseUrl = "#{glados.Settings.GLADOS_BASE_PATH_REL}blog_entries"
      @setMeta('base_url', @baseUrl, true)
      return @baseUrl

    setDataFromResponse: (response) ->
      @setMeta('next_page_token', response.nextPageToken, true)
      @setMeta('total_count', response.totalCount, true)
      entries = response.entries
      @reset(entries)

    getNextPageToken: ->
      nextPageToken = @getMeta('next_page_token')
      return nextPageToken

    getNumberOfRecords: ->
      totalCount = @getMeta('total_count')
      return totalCount

    getPaginatedURL: ->
      nextPageToken = @getNextPageToken()

      if not nextPageToken?
        return @baseUrl
      else
        return "#{@baseUrl}/#{nextPageToken}"

##   Currently the api doesnt return this data
    resetMeta: (page_meta) ->

      @setMeta('total_records', getNumberOfRecords())
      @setMeta('page_size', 15)
      @setMeta('current_page', 1)
      @setMeta('total_pages', getNumberOfRecords()/15)
      @setMeta('records_in_page', page_meta.records_in_page )





