describe 'Target Predictions', ->

  chemblID = 'CHEMBL25'

  it 'generates the correct url', ->

    settings = glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_PREDICTIONS
    flavour = glados.models.paginatedCollections.SpecificFlavours.TargetPredictionsList

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewClientSideCollectionFor(settings,
      generator=undefined, flavour)

    list.initURL(chemblID)

    urlGot = list.url
    urlMustBe = "#{glados.Settings.GLADOS_API_BASE_URL}/target_prediction/predictions/#{chemblID}"
    expect(urlGot).toBe(urlMustBe)