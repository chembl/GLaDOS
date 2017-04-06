describe "Properties Factory for visualisation", ->

  it 'generates the configuration for a property', ->

    prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'ALogP')

    expect(prop.aggregatable).toBe(true)
    expect(prop.label).toBe("ALogP")
    expect(prop.propName).toBe("molecule_properties.alogp")
    expect(prop.type).toBe(Number)

  it 'generates the configuration for a property with default domain', ->

    prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5')
    expect(prop.aggregatable).toBe(true)
    expect(prop.label).toBe("#RO5 Violations")
    expect(prop.propName).toBe("molecule_properties.num_ro5_violations")
    expect(prop.type).toBe(Number)
    expect(prop.domain?).toBe(true)
    expect(prop.coloursRange?).toBe(true)