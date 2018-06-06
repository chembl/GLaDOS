glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  DrugIndicationsList: {}

#    parse: (data) ->
#      data.page_meta.records_in_page = data.drug_indications.length
#      @setMeta('data_loaded', true)
#      @resetMeta(data.page_meta)
#
#      return _.sortBy(data.drug_indications, (di) -> return -di.max_phase_for_ind)