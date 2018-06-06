glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  DrugIndicationsList:

    #-------------------------------------------------------------------------------------------------------------------
    # Initialization
    #-------------------------------------------------------------------------------------------------------------------
    initURL: (chemblID) ->
      @baseUrl = "#{glados.models.paginatedCollections.Settings.ES_BASE_URL}/chembl_drug_indication/_search?q=_metadata.all_molecule_chembl_ids:#{chemblID}"
      @setMeta('base_url', @baseUrl, true)
      @initialiseUrl()

    parse: (data) ->
      data.page_meta.records_in_page = data.drug_indications.length
      @setMeta('data_loaded', true)
      @resetMeta(data.page_meta)

      return _.sortBy(data.drug_indications, (di) -> return -di.max_phase_for_ind)