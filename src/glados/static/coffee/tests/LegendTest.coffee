describe "Legend Model", ->

  describe "Categorical", ->

    it 'initialises from a default domain and tick values', ->

      prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5')
      legendModel = new glados.models.visualisation.LegendModel
        property: prop

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

    it 'selects a value', ->

      prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5')
      legendModel = new glados.models.visualisation.LegendModel
        property: prop
        #collection is not important for this test, can be anything
        collection: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()

      legendModel.selectByPropertyValue(0)
      expect(legendModel.isValueSelected(0)).toBe(true)



