describe "An elasticsearch collection", ->

  describe 'Generated from a list of items (structure searches)', ->

    generatorList = [
      {molecule_chembl_id: "CHEMBL1231413", similarity: "100"}
      {molecule_chembl_id: "CHEMBL3278514", similarity: "75.2252"}
      {molecule_chembl_id: "CHEMBL1491920", similarity: "71.5385"}
      {molecule_chembl_id: "CHEMBL1890154", similarity: "70.684"}
      {molecule_chembl_id: "CHEMBL3183461", similarity: "70.4545"}

    ]
    contextualColumns = [
      {
        comparator: "_score"
        is_elastic_score: true
        is_sorting: 0
        name_to_show: "Similarity"
        position: 3
        show:true
        sort_class: "fa-sort"
        sort_disabled:false
      }
    ]
    searchTerm = 'C1CCC(CC1)C1CCCCC1'
    customQueryString='*'
    customSettings = undefined

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(customQueryString,
          generatorList, contextualColumns, customSettings, searchTerm)

    it 'generates a state object', -> TestsUtils.testSavesList(list,
      pathInSettingsMustBe='ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_COOL_CARDS',
      queryStringMustBe=customQueryString,
      useQueryStringMustBe=false,
      stickyQueryMustBe=undefined,
      esSearchQueryMustBe=undefined,
      searchTermMustBe=searchTerm,
      contextualColumnsMustBe=contextualColumns,
      generatorListMustBe=generatorList
      )

    it 'creates a list from a state object', -> TestsUtils.testRestoredListIsEqualToOriginal(list)



