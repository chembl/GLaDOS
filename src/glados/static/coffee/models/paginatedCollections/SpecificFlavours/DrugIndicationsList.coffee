glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  DrugIndicationsList:

    #-------------------------------------------------------------------------------------------------------------------
    # Initialization
    #-------------------------------------------------------------------------------------------------------------------
    initialize: ->

    initURL: (chemblID) ->
      console.log 'init url'
      @baseUrl = "#{glados.Settings.WS_BASE_URL}drug_indication.json?molecule_chembl_id=#{chemblID}"
      console.log 'base url: ', @baseUrl
      @setMeta('base_url', @baseUrl, true)
      @initialiseUrl()

    parse: (data) ->
      data.page_meta.records_in_page = data.drug_indications.length
      @setMeta('data_loaded', true)
      @resetMeta(data.page_meta)

      return _.sortBy(data.drug_indications, (di) -> return -di.max_phase_for_ind)