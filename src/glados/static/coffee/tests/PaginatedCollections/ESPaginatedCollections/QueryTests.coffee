describe "An elasticsearch collection initialised from a custom query (full)", ->

  esQuery = {
    "query": {
      "match": {
        "molecule_chembl_id": "CHEMBL25"
      }
    }
  }

  esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(esQuery)

  it 'Sets initial parameters', ->

    expect(esList.getMeta('id_name')).toBe("ESCompound")
    expect(esList.getMeta('index')).toBe("/chembl_molecule")
    expect(esList.getMeta('key_name')).toBe("COMPOUND_COOL_CARDS")

#    expect(esList.getMeta('custom_query')).toBe(customQueryString)