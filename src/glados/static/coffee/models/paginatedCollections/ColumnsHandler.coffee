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
      @indexAllColumns()
      @set('enter', [])
      @set('exit', [])

    indexAllColumns: ->

      allColumns = @get('all_columns')
      @set('columns_index', _.indexBy(allColumns, 'comparator'))

    setColumnsPositions: ->

      allColumns = @get('all_columns')
      for i in [1..allColumns.length]
        allColumns[i-1].position = i

    setVisibleColumns: ->

      allColumns = @get('all_columns')
      visibleColumns = _.filter(allColumns, (col) -> col.show)
      @set('visible_columns', visibleColumns)

    setShowHideColumnStatus: (identifier, show) ->

      allColumnsIndex = @get('columns_index')
      allColumnsIndex[identifier].show = show

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
