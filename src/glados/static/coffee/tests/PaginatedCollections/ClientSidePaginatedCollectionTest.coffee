describe 'Client Side Paginated Collection', ->

  describe 'Created from preexisting models', ->

    testModels = ({name: i} for i in [1..100])
    settings = glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.APPROVED_DRUGS_CLINICAL_CANDIDATES_LIST
    settings.preexisting_models = testModels
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewClientSideCollectionFor(settings)

    it 'initialises correctly', ->

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

    it 'Loads the pages correctly', ->

      totalPages = list.getMeta('total_pages')
      pageSize = list.getMeta('records_in_page')

      for i in [1..totalPages]

        list.setPage(i)
        elemsInPage = list.getCurrentPage()
        recordsInPage = list.getMeta('records_in_page')

        for j in [0..recordsInPage-1]

          elem = elemsInPage[j]
          elemNameMustBe = ((i - 1) * pageSize) + (j + 1)
          expect(elem.get('name')).toBe(elemNameMustBe)




