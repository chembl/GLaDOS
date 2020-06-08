glados.useNameSpace 'glados.models.Search',

  # This model handles the communication with the server for structure searches
  StructureSearchModel: Backbone.Model.extend

    initialize: ->

      @setState(glados.models.Search.StructureSearchModel.STATES.INITIAL_STATE)

    submitSearch: ->

      searchType = @get('search_type')
      if searchType == glados.models.Search.StructureSearchModel.SEARCH_TYPES.SEQUENCE.BLAST
        paramsDict = @getSequenceSearchParamsDict()
        submissionURL = glados.Settings.SUBMIT_SEQUENCE_SEARCH_URL
      else
        paramsDict = @getStructureSearchParamsDict()
        submissionURL = glados.Settings.SUBMIT_STRUCTURE_SEARCH_URL

      submitPromise = $.post(submissionURL, paramsDict)

      thisModel = @
      submitPromise.then (data) ->

        thisModel.set('search_id', data.job_id)
        thisModel.setState(glados.models.Search.StructureSearchModel.STATES.SEARCH_QUEUED)

      submitPromise.fail (jqXHR) ->

        errorMSG = if jqXHR.status == 500 then jqXHR.responseText else jqXHR.statusText
        thisModel.set('error_message', errorMSG)
        thisModel.setState(glados.models.Search.StructureSearchModel.STATES.ERROR_STATE)


    getStructureSearchParamsDict: ->

      queryParams = @get('query_params')

      paramsDict =
        search_type: @get('search_type')
        search_term: queryParams.search_term
        threshold: queryParams.threshold
        dl__ignore_cache: false

      return paramsDict

    getSequenceSearchParamsDict: ->

      queryParams = @get('query_params')

      paramsDict = queryParams
      paramsDict.dl__ignore_cache = true

      return paramsDict

    oldSubmitSearch: ->

      paramsDict =
        search_type: @get('search_type')
        raw_search_params: JSON.stringify(@get('query_params'))

      submitPromise = glados.doCSRFPost(glados.Settings.CHEMBL_SUBMIT_SS_SEARCH_ENDPOINT, paramsDict)
      thisModel = @
      submitPromise.then (data) ->

        thisModel.set('search_id', data.search_id)
        thisModel.setState(glados.models.Search.StructureSearchModel.STATES.SEARCH_QUEUED)

    #-------------------------------------------------------------------------------------------------------------------
    # Check search progress
    #-------------------------------------------------------------------------------------------------------------------
    getProgressURL: ->

      search_id = @get('search_id')

      url = glados.Settings.DELAYED_JOB_STATUS_URL_GENERATOR
        job_id: encodeURIComponent(search_id)

      return url

    checkSearchStatusPeriodically: ->

      progressURL = @getProgressURL()
      thisModel = @
      getProgress = $.get(progressURL)

      getProgress.then (response) ->

        statusDescription = response.status_description

        if statusDescription? and statusDescription != 'None'
          parsedStatusDescription = JSON.parse(statusDescription)
          thisModel.set('status_description', parsedStatusDescription)

        status = response.status
        if status == 'ERROR'

          thisModel.set('error_message', response.msg)
          thisModel.setState(glados.models.Search.StructureSearchModel.STATES.ERROR_STATE)

        else if status == 'QUEUED'

          setTimeout(thisModel.checkSearchStatusPeriodically.bind(thisModel), 1000)

        else if status == 'RUNNING'

          thisModel.set('progress', response.progress)
          thisModel.setState(glados.models.Search.StructureSearchModel.STATES.SEARCHING)
          setTimeout(thisModel.checkSearchStatusPeriodically.bind(thisModel), 1000)

        else if status == 'FINISHED'

          thisModel.set('expires', response.expires_at)
          thisModel.setState(glados.models.Search.StructureSearchModel.STATES.FINISHED)

        else

          setTimeout(thisModel.checkSearchStatusPeriodically.bind(thisModel), 1000)

    getContextObj: ->

      searchType = @get('search_type')
      searchID = @get('search_id')

      contextObj = {
        'context_type': searchType,
        'context_id': searchID,
        'delayed_jobs_base_url': glados.Settings.DELAYED_JOBS_BASE_URL
      }

      return contextObj
    #-------------------------------------------------------------------------------------------------------------------
    # State handling
    #-------------------------------------------------------------------------------------------------------------------
    getState: -> @get('state')
    setState: (newState) ->

      if newState == glados.models.Search.StructureSearchModel.STATES.SEARCH_QUEUED
        @checkSearchStatusPeriodically()
      else if newState == glados.models.Search.StructureSearchModel.STATES.FINISHED
        @trigger(glados.models.Search.StructureSearchModel.EVENTS.RESULTS_READY)

      @set('state', newState)

glados.models.Search.StructureSearchModel.STATES =
  INITIAL_STATE: 'INITIAL_STATE'
  ERROR_STATE: 'ERROR_STATE'
  SEARCH_QUEUED: 'SEARCH_QUEUED'
  SEARCHING: 'SEARCHING'
  LOADING_RESULTS: 'LOADING_RESULTS'
  FINISHED: 'FINISHED'
  DELETING: 'DELETING'

glados.models.Search.StructureSearchModel.EVENTS =
  RESULTS_READY: 'RESULTS_READY'

glados.models.Search.StructureSearchModel.SEARCH_TYPES =
  STRUCTURE:
    SIMILARITY: 'SIMILARITY'
    SUBSTRUCTURE: 'SUBSTRUCTURE'
    CONNECTIVITY: 'CONNECTIVITY'
  SEQUENCE:
    BLAST: 'BLAST'