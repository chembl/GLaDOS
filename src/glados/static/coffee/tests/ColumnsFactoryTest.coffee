describe "Columns Factory for paginated views", ->

  it 'generates the configuration for an aggregatable property', ->

#      'name_to_show': 'Molecule Type'

    baseColConfig =
      comparator: 'molecule_type'
    indexName = 'chembl_molecule'

    configGot = glados.models.paginatedCollections.ColumnsFactory.generateColumn(indexName, baseColConfig)

    expect(configGot.comparator).toBe(baseColConfig.comparator)
    expect(configGot.sort_disabled).toBe(false)
    expect(configGot.is_sorting).toBe(0)
    expect(configGot.sort_class).toBe('fa-sort')

  it 'generates the configuration for an non aggregatable property', ->

    baseColConfig =
      comparator: 'molecule_synonyms'
    indexName = 'chembl_molecule'

    configGot = glados.models.paginatedCollections.ColumnsFactory.generateColumn(indexName, baseColConfig)

    expect(configGot.comparator).toBe(baseColConfig.comparator)
    expect(configGot.sort_disabled).toBe(true)
    expect(configGot.is_sorting?).toBe(false)
    expect(configGot.sort_class?).toBe(false)
