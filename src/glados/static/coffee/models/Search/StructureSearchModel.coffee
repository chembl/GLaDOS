glados.useNameSpace 'glados.models.Search',

  # This model handles the communication with the server for structure searches
  StructureSearchModel: Backbone.Model.extend

    initialize: ->

      @setState(glados.models.Search.StructureSearchModel.STATES.INITIAL_STATE)

    submitSearch: ->

      paramsDict =
        search_type: @get('search_type')
        raw_search_params: JSON.stringify(@get('query_params'))

      submitPromise = glados.doCSRFPost(glados.Settings.CHEMBL_SUBMIT_STRUCTURE_SEARCH_ENDPOINT, paramsDict)
      thisModel = @
      submitPromise.then (data) ->

        thisModel.set('search_id', data.search_id)
        thisModel.setState(glados.models.Search.StructureSearchModel.STATES.SEARCH_QUEUED)

      submitPromise.fail (jqXHR) ->

        errorMSG = if jqXHR.status == 500 then jqXHR.responseText else jqXHR.statusText
        thisModel.set('error_message', errorMSG)
        thisModel.setState(glados.models.Search.StructureSearchModel.STATES.ERROR_STATE)

    #-------------------------------------------------------------------------------------------------------------------
    # Check search progress
    #-------------------------------------------------------------------------------------------------------------------
    getProgressURL: -> "#{glados.Settings.GLADOS_BASE_PATH_REL}sssearch-progress/#{@get('search_id')}"
    checkSearchStatusPeriodically: ->

      console.log 'checkSearchStatusPeriodically'
      progressURL = @getProgressURL()
      thisModel = @
      getProgress = $.get(progressURL)

      getProgress.then (response) ->

        status = response.status
        if status == 'ERROR'

          thisModel.set('error_message', response.msg)
          thisModel.setState(glados.models.Search.StructureSearchModel.STATES.ERROR_STATE)

        else if status == 'SEARCH_QUEUED'

          setTimeout(thisModel.checkSearchStatusPeriodically.bind(thisModel), 1000)

        else if status == 'SEARCHING'

          thisModel.setState(glados.models.Search.StructureSearchModel.STATES.SEARCHING)
          setTimeout(thisModel.checkSearchStatusPeriodically.bind(thisModel), 1000)

     #-------------------------------------------------------------------------------------------------------------------
    # State handling
    #-------------------------------------------------------------------------------------------------------------------
    getState: -> @get('state')
    setState: (newState) ->
      @set('state', newState)
      if newState == glados.models.Search.StructureSearchModel.STATES.SEARCH_QUEUED
        @checkSearchStatusPeriodically()






glados.models.Search.StructureSearchModel.STATES =
  INITIAL_STATE: 'INITIAL_STATE'
  ERROR_STATE: 'ERROR_STATE'
  SEARCH_QUEUED: 'SEARCH_QUEUED'
  SEARCHING: 'SEARCHING'