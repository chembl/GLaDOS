glados.useNameSpace 'glados.models.Compound',
  Metabolism: Backbone.Model.extend

    initialize: ->
      @url = glados.models.paginatedCollections.Settings.ES_BASE_URL +
      '/chembl_metabolism/_search?q=drug_chembl_id:' + @get('molecule_chembl_id') + '&size=10000'
