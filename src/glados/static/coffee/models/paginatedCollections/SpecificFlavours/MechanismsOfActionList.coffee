glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  MechanismsOfActionList:

    initURL: (chemblID) ->
      console.log 'init url'
      @baseUrl = "#{glados.Settings.WS_BASE_URL}mechanism.json?molecule_chembl_id=#{chemblID}"
      console.log 'base url: ', @baseUrl
      @setMeta('base_url', @baseUrl, true)
      @initialiseUrl()

    parse: (data) ->
      data.page_meta.records_in_page = data.mechanisms.length
      @setMeta('data_loaded', true)
      @resetMeta(data.page_meta)
      return data.mechanisms