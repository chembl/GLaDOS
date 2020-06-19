# This model handles the communication with the server for server side downloads.
glados.useNameSpace 'glados.models.ServerSideDownloads',

  DownloadModel: Backbone.Model.extend

    initialize: -> @setState(glados.models.ServerSideDownloads.DownloadModel.states.INITIAL_STATE)

    #-------------------------------------------------------------------------------------------------------------------
    # starting download
    #-------------------------------------------------------------------------------------------------------------------
    startServerSideDownload: (desiredFormat) ->

      downloadParams = @getDownloadParams(desiredFormat)
      downloadURL = glados.Settings.SUBMIT_DOWNLOAD_URL
      generateDownload = $.post(downloadURL, downloadParams)

      thisModel = @
      generateDownload.then (response) ->

        thisModel.set('download_id', response.job_id)
        thisModel.set('progress', 0)
        thisModel.setState(glados.models.ServerSideDownloads.DownloadModel.states.GENERATING_DOWNLOAD)

      generateDownload.fail (response) ->                                                      
        thisModel.set('error_msg', response.responseText)
        thisModel.setState(glados.models.ServerSideDownloads.DownloadModel.states.ERROR_STATE)

    getDownloadParams: (desiredFormat) ->

      collection = @get('collection')
      requestData = collection.getRequestData()
      download_columns_group = collection.getMeta('download_columns_group')

      ssSearchModel = collection.getMeta('sssearch_model')
      params = {
        index_name: collection.getMeta('index_name')
        query: JSON.stringify(requestData.query)
        format: desiredFormat
        dl__ignore_cache: false
      }

      if ssSearchModel?

        contextObj = {
          delayed_jobs_base_url: glados.Settings.DELAYED_JOBS_BASE_URL
          context_type: ssSearchModel.get('search_type')
          context_id: ssSearchModel.get('search_id')
        }
        params['context_obj'] = JSON.stringify(contextObj)

      else


      if download_columns_group?
        params['download_columns_group'] = download_columns_group

      return params

    #-------------------------------------------------------------------------------------------------------------------
    # Check download progress
    #-------------------------------------------------------------------------------------------------------------------
    getProgressURL: -> "#{glados.Settings.DELAYED_JOBS_BASE_URL}/status/#{@get('download_id')}"
    checkDownloadProgressPeriodically: ->

      progressURL = @getProgressURL()

      thisModel = @
      getProgress = $.get(progressURL)

      getProgress.then (response) ->

        status = response.status
        if status == 'ERROR'

          thisModel.set('error_msg', response.msg)
          thisModel.setState(glados.models.ServerSideDownloads.DownloadModel.states.ERROR_STATE)

        else if status == 'QUEUED'

          setTimeout(thisModel.checkDownloadProgressPeriodically.bind(thisModel), 2000)

        else if status == 'RUNNING'

          thisModel.set('progress', response.progress)
          setTimeout(thisModel.checkDownloadProgressPeriodically.bind(thisModel), 2000)

        else if status == 'FINISHED'

          thisModel.set('expires', response.expires)

          output_file_url = "https://#{response.output_files_urls[Object.keys(response.output_files_urls)[0]]}"
          thisModel.set('output_file_url', output_file_url)

          thisModel.setState(glados.models.ServerSideDownloads.DownloadModel.states.FINISHED)

        else

          setTimeout(thisModel.checkDownloadProgressPeriodically.bind(thisModel), 2000)

      getProgress.fail (response) ->

        thisModel.set('error_msg', response.statusText)
        thisModel.setState(glados.models.ServerSideDownloads.DownloadModel.states.ERROR_STATE)

    #-------------------------------------------------------------------------------------------------------------------
    # Getting download final url
    #-------------------------------------------------------------------------------------------------------------------
    getDownloadURL: ->

      outputFileURL = @get('output_file_url')
      return outputFileURL

    #-------------------------------------------------------------------------------------------------------------------
    # State handling
    #-------------------------------------------------------------------------------------------------------------------
    getState: -> @get('state')
    setState: (newState) ->
      @set('state', newState)
      if newState == glados.models.ServerSideDownloads.DownloadModel.states.GENERATING_DOWNLOAD
        @checkDownloadProgressPeriodically()

glados.models.ServerSideDownloads.DownloadModel.states =
  INITIAL_STATE: 'INITIAL_STATE'
  ERROR_STATE: 'ERROR_STATE'
  GENERATING_DOWNLOAD: 'GENERATING_DOWNLOAD'
  FINISHED: 'FINISHED'
  DELETING: 'DELETING'