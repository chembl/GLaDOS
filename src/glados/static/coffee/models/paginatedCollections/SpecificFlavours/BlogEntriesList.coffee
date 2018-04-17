glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  BlogEntriesList:
    initURL:->
      @baseUrl = "#{glados.Settings.GLADOS_BASE_PATH_REL}blog_entries"
      @setMeta('base_url', @baseUrl, true)
      return @baseUrl
