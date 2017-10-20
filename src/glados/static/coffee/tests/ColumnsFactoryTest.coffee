describe "Columns Factory for paginated views", ->

  it 'generates the configuration for a property', ->

#{
#      'name_to_show': 'Molecule Type'
#      'comparator': 'molecule_type'
#      'sort_disabled': false
#      'is_sorting': 0
#      'sort_class': 'fa-sort'
#    }

    baseColConfig =
      comparator: 'molecule_type'
    indexName = 'chembl_molecule'

    configGot = glados.models.paginatedCollections.ColumnsFactory.generateColumn(indexName, baseColConfig)

    expect(configGot.comparator).toBe(baseColConfig.comparator)
    expect(configGot.sort_disabled).toBe(false)
    expect(configGot.is_sorting).toBe(0)
    expect(configGot.sort_class).toBe('fa-sort')