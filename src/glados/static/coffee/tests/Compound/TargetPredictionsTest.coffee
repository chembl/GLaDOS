describe 'Target Predictions', ->

  chemblID = 'CHEMBL25'

  it 'generates the correct url', ->

    settings = glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_PREDICTIONS
    flavour = glados.models.paginatedCollections.SpecificFlavours.TargetPredictionsList

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewClientSideCollectionFor(settings,
      generator=undefined, flavour)

    list.initURL(chemblID)

    urlGot = list.url
    urlMustBe = "https://www.ebi.ac.uk/chembl/target-predictions"
    expect(urlGot).toBe(urlMustBe)