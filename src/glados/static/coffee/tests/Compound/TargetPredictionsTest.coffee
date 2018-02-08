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

    settings.generator =
      model: compound
      generator_property: '_metadata.target_predictions'

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewClientSideCollectionFor(settings)
    compound.trigger('change')

    targetPredictionsMustBe = compound.get('_metadata').target_predictions
    expect(targetPredictionsMustBe.length).toBe(list.length)

    for predMustBe in targetPredictionsMustBe
      predID = predMustBe.pred_id
      predGot = list.get(predID)

      expect(predMustBe.molecule_chembl_id).toBe(predGot.get('molecule_chembl_id'))
      expect(predMustBe.probability).toBe(predGot.get('probability'))
      expect(predMustBe.target_accession).toBe(predGot.get('target_accession'))
      expect(predMustBe.target_chembl_id).toBe(predGot.get('target_chembl_id'))

  it 'is generated from a preloaded compound model (filtered)', ->

    settings = glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_PREDICTIONS

    filterFunc = (p) -> p.value == 10
    settings.generator =
      model: compound
      generator_property: '_metadata.target_predictions'
      filter: filterFunc

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewClientSideCollectionFor(settings)
    compound.trigger('change')

    targetPredictionsMustBe = _.filter(compound.get('_metadata').target_predictions, filterFunc)

    for predMustBe in targetPredictionsMustBe
      predID = predMustBe.pred_id
      predGot = list.get(predID)

      expect(predMustBe.molecule_chembl_id).toBe(predGot.get('molecule_chembl_id'))
      expect(predMustBe.probability).toBe(predGot.get('probability'))
      expect(predMustBe.target_accession).toBe(predGot.get('target_accession'))
      expect(predMustBe.target_chembl_id).toBe(predGot.get('target_chembl_id'))
