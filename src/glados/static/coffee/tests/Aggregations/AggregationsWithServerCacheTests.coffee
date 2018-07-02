describe 'Aggregation', ->

  describe 'Using web server cache', ->

    describe 'Using the Compound index', ->

      compoundsAgg = MainPageApp.getYearByMaxPhaseAgg()

      it 'Returns the correct index name', ->

        requestData = compoundsAgg.getESCacheRequestData()
        indexName = requestData.index_name
        expect(indexName).toBe(glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.INDEX_NAME)

    describe 'Using the Target index', ->

      compChemblID = 'CHEMBL25'
      targsAgg = CompoundReportCardApp.getRelatedTargetsAgg(compChemblID)

      it 'Returns the correct index name', ->

        requestData = targsAgg.getESCacheRequestData()
        indexName = requestData.index_name
        expect(indexName).toBe(glados.models.paginatedCollections.Settings.ES_INDEXES.TARGET.INDEX_NAME)

    describe 'Using the assay index', ->

      compChemblID = 'CHEMBL25'
      assAgg = CompoundReportCardApp.getRelatedAssaysAgg(compChemblID)

      it 'Returns the correct index name', ->

        requestData = assAgg.getESCacheRequestData()
        indexName = requestData.index_name
        expect(indexName).toBe(glados.models.paginatedCollections.Settings.ES_INDEXES.ASSAY.INDEX_NAME)

    describe 'Using the document index', ->

      compChemblID = 'CHEMBL25'
      docsAgg = CompoundReportCardApp.getPapersPerYearAgg(compChemblID)

      it 'Returns the correct index name', ->

        requestData = docsAgg.getESCacheRequestData()
        indexName = requestData.index_name
        expect(indexName).toBe(glados.models.paginatedCollections.Settings.ES_INDEXES.DOCUMENT.INDEX_NAME)

    describe 'Using the activity index', ->

      compChemblID = 'CHEMBL25'
      actsAgg = CompoundReportCardApp.getRelatedActivitiesAgg(compChemblID)

      it 'Returns the correct index name', ->

        requestData = actsAgg.getESCacheRequestData()
        indexName = requestData.index_name
        expect(indexName).toBe(glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.ACTIVITY.INDEX_NAME)


