glados.useNameSpace 'glados.models.Search',

  # This model handles the communication with the server for structure searches
  StructureSearchModel: Backbone.Model.extend

    initialize: ->

      @set('state', glados.models.Search.StructureSearchModel.STATES.INITIAL_STATE)

glados.models.Search.StructureSearchModel.STATES =
  INITIAL_STATE: 'INITIAL_STATE'