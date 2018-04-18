glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  BlogEntriesList:
    initURL: ->
      @baseUrl = "#{glados.Settings.GLADOS_BASE_PATH_REL}blog_entries"
      @setMeta('base_url', @baseUrl, true)
      @url = @getPaginatedURL()
      return @baseUrl

    parse: (response) ->
      @setDataFromResponse(response)

    setDataFromResponse: (response) ->
      @setMeta('next_page_token', response.nextPageToken, true)
      @setMeta('total_count', response.totalCount, true)
      entries = response.entries
      @resetMeta(entries)
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

    resetMeta: (entries) ->
      pageSize = glados.models.paginatedCollections.SpecificFlavours.BlogEntriesList.DEFAULT_PAGE_SIZE

      @setMeta('total_records', @getNumberOfRecords())
      @setMeta('page_size', pageSize)
      @setMeta('total_pages', @getNumberOfRecords() / pageSize)
      @setMeta('records_in_page', entries.length)


  #-------------------------------------------------------------------------------------------------------------------
  # fetching...
  #-------------------------------------------------------------------------------------------------------------------

    setPage: (newPageNum) ->
      @setMeta('current_page', newPageNum)
      glados.models.paginatedCollections.WSPaginatedCollection.setPage.call(@, newPageNum)

##   Currently the api doesnt return this data



glados.models.paginatedCollections.SpecificFlavours.BlogEntriesList.DEFAULT_PAGE_SIZE = 15