glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  MechanismsOfActionList:

    initURL: (chemblID) ->
      @url = "#{glados.models.paginatedCollections.Settings.ES_BASE_URL}/chembl_mechanism/_search?q=#{chemblID}"

    parse: (data) ->
      console.log 'PARSING DATA: ', data

      mechanisms = data.hits
      console.log 'mechanisms: ', mechanisms

      data.page_meta.records_in_page = data.mechanisms.length
      @setMeta('data_loaded', true)
      @resetMeta(data.page_meta)
      return data.mechanisms