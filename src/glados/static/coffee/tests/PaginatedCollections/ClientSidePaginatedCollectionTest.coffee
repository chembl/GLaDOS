describe 'Client Side Paginated Collection', ->

  describe 'Created from preexisting models', ->

    it 'initialises correctly', ->

      testModels = ({name: i} for i in [1..100])
      settings = glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.APPROVED_DRUGS_CLINICAL_CANDIDATES_LIST
      list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewClientSideCollectionFor(settings,
        testModels)

      console.log 'testData: ', testModels
      console.log 'list: ', list

      pageSize = list.getMeta('page_size')
      currentPage = list.getMeta('current_page')
      totalPages = list.getMeta('total_pages')
      totalRecords = list.getMeta('total_records')
      recordsInPage = list.getMeta('records_in_page')

      expect(pageSize).toBe(10)
      expect(currentPage).toBe(1)
      expect(totalPages).toBe(10)
      expect(totalRecords).toBe(100)
      expect(recordsInPage).toBe(10)
      expect(list.getMeta('all_items_selected')).toBe(false)
      expect(Object.keys(list.getMeta('selection_exceptions')).length).toBe(0)
