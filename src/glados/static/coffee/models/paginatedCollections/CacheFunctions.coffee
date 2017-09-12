glados.useNameSpace 'glados.models.paginatedCollections',

  CacheFunctions:

    initCache: -> @setMeta('cache', {})
    addObjectToCache: (obj, position) -> @getMeta('cache')[position] = obj
    resetCache: -> @initCache()
    getObjectInCache: (position) -> @getMeta('cache')[position]