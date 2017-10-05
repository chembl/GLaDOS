glados.useNameSpace 'glados.models.paginatedCollections',

  # --------------------------------------------------------------------------------------------------------------------
  # This class implements the functionalities to build an Elastic Search query
  # --------------------------------------------------------------------------------------------------------------------
  ColumnsHandler: Backbone.Model.extend
    initialize: ->

      defaultColumns = @get('default_columns')
      if defaultColumns?
        for col in defaultColumns
          col.show = true

      contextualProperties = @get('contextual_properties')
      if contextualProperties?
        for col in contextualProperties
          col.show = true

      additionalColumns = @get('additional_columns')
      if additionalColumns?
        for col in additionalColumns
          col.show = false

      allColumns = _.union(defaultColumns, contextualProperties, additionalColumns)
      @set('all_columns', allColumns)
      @setColumnsPositions()

      @setVisibleColumns()

    setColumnsPositions: ->

      allColumns = @get('all_columns')
      for i in [1..allColumns.length]
        allColumns[i-1].position = i

    setVisibleColumns: ->

      allColumns = @get('all_columns')
      visibleColumns = _.filter(allColumns, (col) -> col.show)
      @set('visible_columns', visibleColumns)

    setShowHideColumnStatus: (identifier, show) ->

      allColumns = @get('all_columns')
      changedColumn = _.find(allColumns, (col) -> col.comparator == identifier)
      changedColumn.show = show

      @setVisibleColumns()

    setShowHideAllColumnStatus: (show) ->

      allColumns = @get('all_columns')
      for col in allColumns
        col.show = show

      @setVisibleColumns()

    changeColumnsOrder: (receivingProperty, draggedProperty) ->

      if receivingProperty == draggedProperty
        return

      allColumns = @get('all_columns')
      draggedColumn = undefined

      for i in [0..allColumns.length-1]
        col = allColumns[i]
        if col.comparator == draggedProperty
          draggedColumn = col
          allColumns.splice(i, 1)
          break

      for i in [0..allColumns.length-1]
        col = allColumns[i]
        if col.comparator == receivingProperty
          allColumns.splice(i, 0, draggedColumn)
          break

      @setVisibleColumns()
