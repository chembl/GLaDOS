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