glados.useNameSpace 'glados.models.paginatedCollections',

  ColumnsHandler: Backbone.Model.extend
    initialize: ->

      defaultColumns = @get('default_columns')
      if defaultColumns?
        for col in defaultColumns
          col.show = true
      else
        defaultColumns = []


      contextualProperties = @get('contextual_properties')
      if contextualProperties?
        for col in contextualProperties
          col.show = true
      else
        contextualProperties = []

      additionalColumns = @get('additional_columns')
      if additionalColumns?
        for col in additionalColumns
          col.show = false
      else
        additionalColumns = []

      allColumns = _.union(defaultColumns, contextualProperties, additionalColumns)
      if @get 'include_highlights_column'
        srhColumn = glados.models.paginatedCollections.ColumnsFactory.getSearchResultsHighlightColumn()
        if allColumns?
          allColumns.splice 1, 0, srhColumn
        else
          allColumns = [srhColumn]

      allColumns ?= []
      @set('all_columns', allColumns)
      @setColumnsPositions()
      @setVisibleColumns()
      @indexAllColumns()
      @set('enter', [])
      @set('exit', [])

    indexAllColumns: ->

      allColumns = @get('all_columns')
      @set('columns_index', _.indexBy(allColumns, 'prop_id'))

    setColumnsPositions: ->

      allColumns = @get('all_columns')
      if allColumns.length == 0
        return
      positionsChanged = false
      for i in [1..allColumns.length]

        if allColumns[i-1].position != i
          positionsChanged = true
        allColumns[i-1].position = i

      if positionsChanged
        @trigger(glados.models.paginatedCollections.ColumnsHandler.EVENTS.COLUMNS_ORDER_CHANGED)

    setVisibleColumns: ->

      allColumns = @get('all_columns')
      visibleColumns = _.filter(allColumns, (col) -> col.show)
      @set('visible_columns', visibleColumns)

    setShowHideColumnStatus: (identifier, show) ->

      allColumnsIndex = @get('columns_index')
      changedColumn = allColumnsIndex[identifier]
      changedColumn.show = show

      if show
        enter = [identifier]
        @set
          enter: enter
          exit: []
      else
        exit = [identifier]
        @set
          enter: []
          exit: exit

      @setVisibleColumns()

    setShowHideAllColumnStatus: (show) ->

      allColumns = @get('all_columns')
      identifiers = []
      for col in allColumns
        if col.show != show
          col.show = show
          identifiers.push col.prop_id

      if show
        @set
          enter: identifiers
          exit: []
      else
        @set
          enter: []
          exit: identifiers

      @setVisibleColumns()

    changeColumnsOrder: (receivingProperty, draggedProperty) ->

      if receivingProperty == draggedProperty
        return

      allColumns = @get('all_columns')
      draggedColumn = undefined

      for i in [0..allColumns.length-1]
        col = allColumns[i]
        if col.prop_id == draggedProperty
          draggedColumn = col
          allColumns.splice(i, 1)
          break

      for i in [0..allColumns.length-1]
        col = allColumns[i]
        if col.prop_id == receivingProperty
          allColumns.splice(i, 0, draggedColumn)
          break

      @setVisibleColumns()
      @setColumnsPositions()

    getPropertyLabel: (propertyName) -> @get('columns_index')[propertyName].name_to_show

glados.models.paginatedCollections.ColumnsHandler.EVENTS =
  COLUMNS_ORDER_CHANGED: 'COLUMNS_ORDER_CHANGED'