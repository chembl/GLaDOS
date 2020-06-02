describe 'FacetsConfigurationModel', ->

  it 'Generates the correct url', ->

    indexName = 'chembl_molecule'
    groupName = 'browser_facets'

    facetsConfigModel = new glados.models.paginatedCollections.esSchema.FacetsConfigurationModel
      index_name: indexName
      group_name: groupName

    urlMustBe = glados.Settings.FACETS_GROUP_CONFIGURATION_URL_GENERATOR
      index_name: indexName
      group_name: groupName

    urlGot = facetsConfigModel.url
    expect(urlMustBe).toBe(urlGot)
