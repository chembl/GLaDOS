glados.useNameSpace 'glados.models.paginatedCollections',

  # --------------------------------------------------------------------------------------------------------------------
  # This class implements the functionalities to build an Elastic Search query
  # --------------------------------------------------------------------------------------------------------------------
  ColumnsHandler: Backbone.Model.extend
    initialize: ->

      console.log 'INIT ColumnsHandler'
      console.log 'Default Columns: ', @get('default_columns')
      console.log 'Additional Columns: ', @get('additional_columns')

      defaultColumns = @get('default_columns')
      if defaultColumns?
        for col in defaultColumns
          col.show = true

      additionalColumns = @get('additional_columns')
      if additionalColumns?
        for col in additionalColumns
          col.show = false

      allColumns = _.union(defaultColumns, additionalColumns)
      console.log 'allColumns: ', allColumns
      @set('all_columns', allColumns)
