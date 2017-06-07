describe "Properties Factory for visualisation", ->

  it 'generates the configuration for a property', ->

    prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'ALogP')

    expect(prop.aggregatable).toBe(true)
    expect(prop.label).toBe("ALogP")
    expect(prop.propName).toBe("molecule_properties.alogp")
    expect(prop.type).toBe(Number)

  describe 'with a default domain', ->

    describe 'categorical', ->

      prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5',
          withColourScale=true)

      it 'generates the basic configuration', ->

        expect(prop.aggregatable).toBe(true)
        expect(prop.label).toBe("#RO5 Violations")
        expect(prop.propName).toBe("molecule_properties.num_ro5_violations")
        expect(prop.type).toBe(Number)
        expect(prop.domain?).toBe(true)
        expect(prop.coloursRange?).toBe(true)

      it 'generates a colour scale when requested', ->

        scale = prop.colourScale
        domainMustBe = [glados.Settings.DEFAULT_NULL_VALUE_LABEL, 0, 1, 2, 3, 4]
        rangeMustBe = [glados.Settings.VISUALISATION_GREY_BASE, '#e3f2fd', '#90caf9', '#42a5f5', '#1976d2', '#0d47a1']
        domainGot = scale.domain()
        rangeGot = scale.range()

        for i in [0..domainMustBe.length - 1]
          expect(domainGot[i]).toBe(domainMustBe[i])
        for i in [0..rangeMustBe.length - 1]
          expect(rangeGot[i]).toBe(rangeMustBe[i])

    describe 'Threshold', ->

      prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Activity', 'STANDARD_VALUE',
        withColourScale=true)

      it 'generates the basic configuration', ->

        expect(prop.aggregatable).toBe(true)
        expect(prop.label).toBe("Standard Value nM")
        expect(prop.propName).toBe("standard_value")
        expect(prop.type).toBe(Number)
        expect(prop.domain?).toBe(true)
        expect(prop.coloursRange?).toBe(true)

      it 'generates a colour scale when requested', ->

        scale = prop.colourScale
        domain = prop.domain
        range = prop.coloursRange
        bottom = -Number.MAX_VALUE
        top = Number.MAX_VALUE
        domainForTest = _.union([bottom], domain, [top])
        for i in [0..domain.length]
          a = domainForTest[i]
          b = domainForTest[i+1]
          testVal = (Math.random() * (b - a)) + a
          expect(scale(testVal)).toBe(range[i])

  describe 'with a unknown domain', ->

    describe 'continuous', ->

      prop = undefined
      beforeEach ->
        prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'FULL_MWT')

      testGeneratesTheDomainFromAListOfValues = (prop) ->

        minVal = (Math.random() * 1000) - 500
        maxVal = minVal + (Math.random() * 1000)
        values = TestsUtils.generateListOfRandomValues(minVal, maxVal)
        glados.models.visualisation.PropertiesFactory.generateContinuousDomainFromValues(prop, values)
        expect(prop.domain[0]).toBe(minVal)
        expect(prop.domain[1]).toBe(maxVal)

      it 'generates the basic configuration', ->

        expect(prop.aggregatable).toBe(true)
        expect(prop.label).toBe("Parent Molecular Weight")
        expect(prop.propName).toBe("molecule_properties.full_mwt")
        expect(prop.type).toBe(Number)
        expect(prop.domain?).toBe(false)
        expect(prop.coloursRange?).toBe(true)

      it 'generates the domain from a list of values', ->
        for i in [1..10]
          testGeneratesTheDomainFromAListOfValues(prop)

      it 'generates a colour scale when requested after generating domain', ->

        minVal = (Math.random() * 1000) - 500
        maxVal = minVal + (Math.random() * 1000)
        values = TestsUtils.generateListOfRandomValues(minVal, maxVal)
        glados.models.visualisation.PropertiesFactory.generateContinuousDomainFromValues(prop, values)
        glados.models.visualisation.PropertiesFactory.generateColourScale(prop)

        scale = prop.colourScale
        domainMustBe = [minVal, maxVal]
        rangeMustBe = [glados.Settings.VISUALISATION_LIGHT_BLUE_MIN, glados.Settings.VISUALISATION_LIGHT_BLUE_MAX]
        domainGot = scale.domain()
        rangeGot = scale.range()

        for i in [0..domainMustBe.length - 1]
          expect(domainGot[i]).toBe(domainMustBe[i])
        for i in [0..rangeMustBe.length - 1]
          expect(rangeGot[i]).toBe(rangeMustBe[i])

      describe 'property without esIndex', ->

        prop = undefined
        beforeEach ->
          prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('CompoundTargetMatrix',
            'PCHEMBL_VALUE_AVG')

        it 'generates the basic configuration', ->

          expect(prop.label).toBe("PChEMBL Value Avg")
          expect(prop.propName).toBe("pchembl_value_avg")
          expect(prop.type).toBe(Number)