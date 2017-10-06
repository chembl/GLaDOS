describe 'Columns Handler', ->

  describe 'For Paginated Collection Columns', ->

    columnsHandler = undefined

    beforeEach ->

      defaultColumns = Compound.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
      additionalColumns = Compound.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD_ADDITIONAL
      contextualProperties = []

      columnsHandler = new glados.models.paginatedCollections.ColumnsHandler
        default_columns: defaultColumns
        additional_columns: additionalColumns
        contextual_properties: contextualProperties

    it 'Changes the state when showing or hiding a column', ->

      allColumns = columnsHandler.get('all_columns')
      columnsIndex = columnsHandler.get('columns_index')

      # show a hidden column
      hiddenColumnIdentifier = _.find(allColumns, (col) -> not col.show).comparator
      columnsHandler.setShowHideColumnStatus(hiddenColumnIdentifier, true)
      expect(columnsIndex[hiddenColumnIdentifier].show).toBe(true)
      expect(columnsHandler.get('enter')[0]).toBe(hiddenColumnIdentifier)

      # hide a visible column
      visibleColumnIdentifier = _.find(allColumns, (col) -> col.show).comparator
      columnsHandler.setShowHideColumnStatus(hiddenColumnIdentifier, false)
      expect(columnsIndex[visibleColumnIdentifier].show).toBe(false)
      expect(columnsHandler.get('exit')[0]).toBe(visibleColumnIdentifier)

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