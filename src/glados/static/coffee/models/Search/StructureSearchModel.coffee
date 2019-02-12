glados.useNameSpace 'glados.models.Search',

  # This model handles the communication with the server for structure searches
  StructureSearchModel: Backbone.Model.extend

    initialize: ->

      @set('state', glados.models.Search.StructureSearchModel.STATES.INITIAL_STATE)

    submitSearch: ->

      paramsDict = @get('query_params')
      glados.doCSRFPost(glados.Settings.CHEMBL_STRUCTURE_SEARCH_HELPER_ENDPOINT, paramsDict)

glados.models.Search.StructureSearchModel.STATES =
  INITIAL_STATE: 'INITIAL_STATE'