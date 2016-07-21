Target = Backbone.RelationalModel.extend

  idAttribute: 'target_chembl_id'

  initialize: ->
    @on 'change', @test, @
    @url = 'https://www.ebi.ac.uk/chembl/api/data/target/' + @get('target_chembl_id') + '.json'

  test: ->
    console.log('target changed!')
    console.log(@toJSON())
    console.log('^^^')