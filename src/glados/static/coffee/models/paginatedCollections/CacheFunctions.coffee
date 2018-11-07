glados.useNameSpace 'glados.models.paginatedCollections',

  CacheFunctions:

    #-------------------------------------------------------------------------------------------------------------------
    # Basic functions
    #-------------------------------------------------------------------------------------------------------------------
    initCache: -> @setMeta('cache', {})
    addObjectToCache: (obj, position) -> @getMeta('cache')[position] = obj
    resetCache: -> @initCache()
    getObjectInCache: (position) -> @getMeta('cache')[position]

    getObjectsInCache: (startPosition, endPosition) ->

      cache = @getMeta('cache')

      if Object.keys(cache).length == 0
        return []

      if endPosition < startPosition
        return []

      objs = []
      for pos in [startPosition..endPosition]
        objs.push cache[pos]

      return objs

    #-------------------------------------------------------------------------------------------------------------------
    # Page oriented functions
    #-------------------------------------------------------------------------------------------------------------------
    addObjectsToCacheFromPage: (objects, page) ->

      startingPosition = @getMeta('page_size') * (page - 1)

      cache = @getMeta('cache')
      for i in [0..objects.length-1]
        position = startingPosition + i
        cache[position] = objects[i]

    # If it is not possible to get the entire page from cache, it returns undefined.
    getObjectsInCacheFromPage: (pageNum) ->

      cache = @getMeta('cache')

      if Object.keys(cache).length == 0
        return []

      totalPages = @getMeta('total_pages')
      if pageNum > totalPages
        return undefined

      pageSize = @getMeta('page_size')
      startPosition = pageSize * (pageNum - 1)
      endPosition = startPosition + (pageSize - 1)

      answer = @getObjectsInCache(startPosition, endPosition)
      isLastPage = pageNum == totalPages

      if isLastPage

        return _.filter(answer, (obj) -> obj?)

      else
        # don't return incomplete cache results, it has all the page or doesn't
        for obj in answer
          if not obj?
            return undefined


      return answer

    addModelsInCurrentPage: ->

      # when fetching per item number the solution is not yet there.
      if @getMeta('fetching_mode') ==\
      glados.models.paginatedCollections.ESPaginatedQueryCollection.FETCHING_MODES.BY_PAGES

        @addObjectsToCacheFromPage(@models, @getMeta('current_page'))
