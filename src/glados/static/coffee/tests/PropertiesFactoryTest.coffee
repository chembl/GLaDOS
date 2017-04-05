describe "Properties Factory for visualisation", ->

  it 'generates the configuration for a property', ->

    prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'ALogP')

    expect(prop.aggregatable).toBe(true)
    expect(prop.label).toBe("ALogP")
    expect(prop.propName).toBe("molecule_properties.alogp")
    expect(prop.type).toBe(Number)

  it 'generates the configuration for a property with default domain and tick values', ->

    prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5')
    expect(prop.aggregatable).toBe(true)
    expect(prop.label).toBe("#RO5 Violations")
    expect(prop.propName).toBe("molecule_properties.num_ro5_violations")
    expect(prop.type).toBe(Number)
    expect(prop.domain[0]).toBe(0)
    expect(prop.domain[1]).toBe(4)
    expect(prop.tickValues[0]).toBe(0)
    expect(prop.tickValues[1]).toBe(1)
    expect(prop.tickValues[2]).toBe(2)
    expect(prop.tickValues[3]).toBe(3)
    expect(prop.tickValues[4]).toBe(4)