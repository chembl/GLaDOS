glados.useNameSpace 'glados.models.Search',

  # This model handles the communication with the server for structure searches
  StructureSearchModel: Backbone.Model.extend

    initialize: ->

      @set('state', glados.models.Search.StructureSearchModel.STATES.INITIAL_STATE)

    submitSearch: ->

      paramsDict =
        search_type: @get('search_type')
        raw_search_params: JSON.stringify(@get('query_params'))

      submitPromise = glados.doCSRFPost(glados.Settings.CHEMBL_SUBMIT_STRUCTURE_SEARCH_ENDPOINT, paramsDict)
      thisModel = @
      submitPromise.then (data) ->

        thisModel.set('search_id', data.search_id)
        thisModel.set('state', glados.models.Search.StructureSearchModel.STATES.SEARCH_QUEUED)

      submitPromise.fail (jqXHR) ->

        errorMSG = if jqXHR.status == 500 then jqXHR.responseText else jqXHR.statusText
        thisModel.set('error_message', errorMSG)
        thisModel.set('state', glados.models.Search.StructureSearchModel.STATES.ERROR_STATE)

glados.models.Search.StructureSearchModel.STATES =
  INITIAL_STATE: 'INITIAL_STATE'
  ERROR_STATE: 'ERROR_STATE'
  SEARCH_QUEUED: 'SEARCH_QUEUED'