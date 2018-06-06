describe 'Drug Indications List', ->

  it 'Sets up the list properties correctly', ->

    testChemblID = 'CHEMBL1094636'
    drugIndicationsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugIndicationsList(testChemblID)

    propertiesMustBe =
      id_name: 'ESDrugIndications'
      label: 'Drug Indications'
      index_name: 'chembl_drug_indication'

    for  key, valueMustBe of propertiesMustBe
      valueGot = drugIndicationsList.getMeta(key)
      expect(valueMustBe).toBe(valueGot)


  it 'Sets up the query string correctly', ->

    testChemblID = 'CHEMBL1094636'
    drugIndicationsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDrugIndicationsList(testChemblID)

    queryStringMustBe = "_metadata.all_molecule_chembl_ids:#{testChemblID}"
    queryStringGot = drugIndicationsList.getMeta('custom_query_string')

    expect(queryStringGot).toBe(queryStringMustBe)

    useCustomQueryStringMustBe = true
    useCustomQueryStringGot = drugIndicationsList.getMeta('use_custom_query_string')
    expect(useCustomQueryStringGot).toBe(useCustomQueryStringMustBe)


