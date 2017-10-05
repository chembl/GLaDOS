describe 'Columns Handler', ->

  describe 'For Paginated Collection Columns', ->

    columnsHandler = undefined

    beforeAll ->

      defaultColumns = Compound.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
      additionalColumns = Compound.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD_ADDITIONAL
      contextualProperties = []

      columnsHandler = new glados.models.paginatedCollections.ColumnsHandler
        default_columns: defaultColumns
        additional_columns: additionalColumns
        contextual_properties: contextualProperties


    it 'Changes the order of the columns', ->

      allColumns = columnsHandler.get('all_columns')
      initialColumnsLength = allColumns.length

      for draggedIndex in [0..allColumns.length-1]
        for receivingIndex in [0..allColumns.length-1]

          comparators = (col.comparator for col in allColumns)

          draggedProperty = comparators[draggedIndex]
          receivingProperty = comparators[receivingIndex]

          comparators.splice(receivingIndex, 0, draggedProperty)
          if draggedIndex >= receivingIndex
            comparators.splice(draggedIndex + 1, 1)
          else
            comparators.splice(draggedIndex, 1)

          columnsHandler.changeColumnsOrder(receivingProperty, draggedProperty)
          expect(initialColumnsLength).toBe(allColumns.length)

          for i in [0..comparators.length-1]
            expect(comparators[i]).toBe(allColumns[i].comparator)