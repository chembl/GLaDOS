glados.useNameSpace 'glados.models.paginatedCollections',

  # --------------------------------------------------------------------------------------------------------------------
  # This class implements the functionalities to build an Elastic Search query
  # --------------------------------------------------------------------------------------------------------------------
  ColumnsHandler: Backbone.Model.extend
    initialize: -> console.log 'INIT COLUMNS HANDLER!!'