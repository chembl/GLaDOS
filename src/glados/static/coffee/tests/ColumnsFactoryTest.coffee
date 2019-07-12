describe "Columns Factory for paginated views", ->

  it 'generates the configuration for an aggregatable property DELETE', ->

    baseColConfig =
      comparator: 'molecule_type'
    indexName = 'chembl_molecule'

    configGot = glados.models.paginatedCollections.ColumnsFactory.generateColumn(indexName, baseColConfig)
    console.log('configGot before: ', configGot)

    expect(configGot.comparator).toBe(baseColConfig.comparator)
    expect(configGot.sort_disabled).toBe(false)
    expect(configGot.is_sorting).toBe(0)
    expect(configGot.sort_class).toBe('fa-sort')
    expect(configGot.label_id).toBe('glados_es_gs__molecule__molecule_type__label')
    expect(configGot.name_to_show).toBe('Type')

  it 'generates the configuration for an non aggregatable property DELETE', ->

    baseColConfig =
      comparator: 'molecule_synonyms'
    indexName = 'chembl_molecule'

    configGot = glados.models.paginatedCollections.ColumnsFactory.generateColumn(indexName, baseColConfig)

    expect(configGot.comparator).toBe(baseColConfig.comparator)
    expect(configGot.sort_disabled).toBe(true)
    expect(configGot.is_sorting?).toBe(false)
    expect(configGot.sort_class?).toBe(false)
    expect(configGot.label_id).toBe('glados_es_gs__molecule__molecule_synonyms__label')
    expect(configGot.name_to_show).toBe('Synonyms')

  it 'generates the configuration for an aggregatable property 2', ->

    configFromServer = {
      "sortable": true,
      "prop_id": "molecule_chembl_id",
      "index_name": "chembl_molecule",
      "label": "ChEMBL ID",
      "label_mini": "ChEMBL ID",
      "aggregatable": true,
      "type": "string"
    }

    configGot = glados.models.paginatedCollections.ColumnsFactory2.generateColumn(configFromServer)
    console.log('configGot: ', configGot)

    expect(configGot.comparator).toBe(configFromServer.prop_id)
    expect(configGot.sort_disabled).toBe(false)
    expect(configGot.is_sorting).toBe(0)
    expect(configGot.sort_class).toBe('fa-sort')
    expect(configGot.name_to_show).toBe('ChEMBL ID')

