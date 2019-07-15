describe 'PropertiesConfigurationModel', ->

  it 'Generates the correct url', ->

    indexName = 'chembl_molecule'
    groupName = 'molecule_chembl_id'

    console.log('WORKS!!!')
    propertiesConfigModel = new glados.models.paginatedCollections.esSchema.PropertiesConfigurationModel
      index_name: indexName
      group_name: groupName

    urlMustBe = glados.Settings.PROPERTIES_GROUP_CONFIGURATION_URL_GENERATOR
      index_name: indexName
      group_name: groupName

    urlGot = propertiesConfigModel.url
    expect(urlMustBe).toBe(urlGot)
