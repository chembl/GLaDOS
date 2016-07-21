Assay = Backbone.RelationalModel.extend

  idAttribute: 'assay_chembl_id'

  initialize: ->
    # it seems that the autoFetch property doesn't work
    @on 'change', @fetchRelatedModels, @

    @url = 'https://www.ebi.ac.uk/chembl/api/data/assay/' + @get('assay_chembl_id') + '.json'

  relations: [{
    type: Backbone.HasOne
    key: 'target'
    relatedModel: 'Target'
  }]

  fetchRelatedModels: ->

    @getAsync('target')

  parse: (data) ->

    parsed = data
    parsed.target = data.target_chembl_id

    return parsed