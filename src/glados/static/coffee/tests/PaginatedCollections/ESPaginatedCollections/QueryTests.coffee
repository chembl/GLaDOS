describe "An elasticsearch collection initialised from a custom query (full)", ->
  esQuery = {
    "query": {
      "bool": {
        "must": [
          {
            "multi_match": {
              "query": "CHEMBL5607",
              "fields": "_metadata.related_targets.chembl_ids.*"
            }
          }
        ],
        "filter": []
      }
    }
  }

  esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(JSON.stringify(esQuery))

  it 'Sets initial parameters', ->
    console.log 'esQuery: ', JSON.stringify(esQuery)
    console.log 'query: ', Compound.getCompoundsListURL(JSON.stringify(esQuery))
    expect(esList.getMeta('id_name')).toBe("ESCompound")
    expect(esList.getMeta('index')).toBe("/chembl_molecule")
    expect(esList.getMeta('key_name')).toBe("COMPOUND_COOL_CARDS")
    esQueryGot = esList.getMeta('custom_query')
    expect(_.isEqual(esQueryGot, JSON.stringify(esQuery))).toBe(true)

  it 'Distinguishes between a query string and a full query', ->
    expect(esList.customQueryIsFullQuery()).toBe(true)

  it 'Generates the correct request object', ->

    requestDataMustBe = {
      "size": 24,
      "from": 0,
      "_source": ["molecule_chembl_id", "molecule_properties.num_ro5_violations", "molecule_properties.full_molformula",
        "molecule_type", "natural_product", "polymer_flag", "structure_type"],
      "query": {
        "bool": {
          "must": [{
            "multi_match": {
              "query": "CHEMBL5607",
              "fields": "_metadata.related_targets.chembl_ids.*"
            }
          }], "filter": []
        }
      },
      "sort": []
    }

    requestDataGot = esList.getRequestData()
    requestDataGot.sort = []
    expect(_.isEqual(requestDataGot, requestDataMustBe)).toBe(true)

  it 'generates a state object', -> TestsUtils.testSavesList(esList,
    pathInSettingsMustBe = 'ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_COOL_CARDS',
    queryStringMustBe = JSON.stringify(esQuery),
    useQueryStringMustBe = true)

  it 'creates a list from a state object', -> TestsUtils.testRestoredListIsEqualToOriginal(esList)

