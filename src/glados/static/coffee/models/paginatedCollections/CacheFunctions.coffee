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

      if startPosition == endPosition
        return [cache[startPosition]]

      objs = []

      for pos in [startPosition..endPosition-1]
        objs.push cache[pos]

      return objs

    #-------------------------------------------------------------------------------------------------------------------
    # Page oriented functions
    #-------------------------------------------------------------------------------------------------------------------
    addObjectsToCacheFromPage: (objects, page) ->

      startingPosition = objects.length * (page - 1)

      cache = @getMeta('cache')
      for i in [0..objects.length-1]
        position = startingPosition + i
        cache[position] = objects[i]
