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
