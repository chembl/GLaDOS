describe 'Target Predictions', ->

  chemblID = 'CHEMBL25'
  compound = new Compound
    molecule_chembl_id: chemblID
    fetch_from_elastic: true

  beforeAll (done) ->

    dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL25esResponse.json'
    $.get dataURL, (testData) ->
      esResponse = testData
      compound.set(compound.parse(esResponse))
      done()


  it 'is generated from a preloaded compound model', ->

    settings = glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_PREDICTIONS

    console.log 'compound: ', compound
    settings.generator =
      model: compound
      generator_property: '_metadata.target_predictions'

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewClientSideCollectionFor(settings)

    targetPredictionsMustBe = compound.get('_metadata').target_predictions
    console.log 'targetPreidctionsMustBe: ', targetPredictionsMustBe

    console.log 'list: ', list