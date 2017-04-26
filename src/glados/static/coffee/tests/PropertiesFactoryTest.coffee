describe "Properties Factory for visualisation", ->

  it 'generates the configuration for a property', ->

    prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'ALogP')

    expect(prop.aggregatable).toBe(true)
    expect(prop.label).toBe("ALogP")
    expect(prop.propName).toBe("molecule_properties.alogp")
    expect(prop.type).toBe(Number)

  describe 'with a default domain ', ->

    describe 'categorical', ->
      it 'generates the configuration', ->

        prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5')
        expect(prop.aggregatable).toBe(true)
        expect(prop.label).toBe("#RO5 Violations")
        expect(prop.propName).toBe("molecule_properties.num_ro5_violations")
        expect(prop.type).toBe(Number)
        expect(prop.domain?).toBe(true)
        expect(prop.coloursRange?).toBe(true)

      it 'generates a colour scale when requested', ->

        prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5',
          withColourScale=true)

        scale = prop.colourScale
        domainMustBe = [glados.Settings.DEFAULT_NULL_VALUE_LABEL, 0, 1, 2, 3, 4]
        rangeMustBe = [glados.Settings.VISUALISATION_GREY_BASE, '#e3f2fd', '#90caf9', '#42a5f5', '#1976d2', '#0d47a1']
        domainGot = scale.domain()
        rangeGot = scale.range()

        for i in [0..domainMustBe.length - 1]
          expect(domainGot[i]).toBe(domainMustBe[i])
        for i in [0..rangeMustBe.length - 1]
          expect(rangeGot[i]).toBe(rangeMustBe[i])

