glados.useNameSpace 'glados.models.paginatedCollections',

  CacheFunctions:

    #-------------------------------------------------------------------------------------------------------------------
    # Basic functions
    #-------------------------------------------------------------------------------------------------------------------
    initCache: -> @setMeta('cache', {})
    addObjectToCache: (obj, position) -> @getMeta('cache')[position] = obj
    resetCache: -> @initCache()
    getObjectInCache: (position) -> @getMeta('cache')[position]

    #-------------------------------------------------------------------------------------------------------------------
    # Page oriented functions
    #-------------------------------------------------------------------------------------------------------------------
    addObjectsToCacheFromPage: (objects, page) ->

      startingPosition = objects.length * (page - 1)

      cache = @getMeta('cache')
      for i in [0..objects.length-1]
        position = startingPosition + i
        cache[position] = objects[i]

