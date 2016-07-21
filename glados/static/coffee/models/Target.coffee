Target = Backbone.RelationalModel.extend

  idAttribute: 'target_chembl_id'

  initialize: ->
    @url = 'https://www.ebi.ac.uk/chembl/api/data/target/' + @get('target_chembl_id') + '.json'

