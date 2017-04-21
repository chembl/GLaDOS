describe "Legend Model", ->

  describe "Categorical", ->

    prop = undefined
    legendModel = undefined
    collection = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()

    beforeAll (done) ->
       TestsUtils.simulateDataWSClientList(
         collection, glados.Settings.STATIC_URL + 'testData/SearchResultsDopamineTestData.json', done)

    beforeEach ->

      prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5')
      legendModel = new glados.models.visualisation.LegendModel
        property: prop
        collection: collection

    it 'initialises from a default domain and tick values', ->

      allItemsIDs = (model.attributes.molecule_chembl_id for model in collection.models)
      console.log 'allItemsIDs: ', allItemsIDs
      domain = legendModel.get('domain')
      ticks = legendModel.get('ticks')

      i = 0
      while i < 5
        expect(domain[i]).toBe(i)
        expect(ticks[i]).toBe(i)
        i++
        
      expect(legendModel.get('type')).toBe(glados.models.visualisation.LegendModel.DISCRETE)
      range = legendModel.get('colour-range')
      rangeShouldBe = ['#e3f2fd', '#90caf9', '#42a5f5', '#1976d2', '#0d47a1']

      for comparison in _.zip(range, rangeShouldBe)
        expect(comparison[0]).toBe(comparison[1])

    it 'initialises the amount of items per category', ->


    it 'selects a value', ->

      legendModel.selectByPropertyValue(0)
      expect(legendModel.isValueSelected(0)).toBe(true)



