describe "Properties Factory for visualisation", ->

  it 'generates the configuration for a property', ->

    propAlogP = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'ALogP')

    expect(propAlogP.aggregatable).toBe(true)
    expect(propAlogP.label).toBe("ALogP")
    expect(propAlogP.propName).toBe("molecule_properties.alogp")
    expect(propAlogP.type).toBe(Number)