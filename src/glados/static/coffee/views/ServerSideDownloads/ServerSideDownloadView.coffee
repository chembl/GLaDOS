glados.useNameSpace 'glados.views.ServerSideDownloads',
  # View that renders the search facet to filter results
  ServerSideDownloadView: Backbone.View.extend

    initialize: ->

      @model.on 'change:state', @renderDownloadState, @
      @model.on 'change:progress', @renderWhenGeneratingDownload, @
      @$errorElem = $(@el).find('.BCK-download-error-msg')
      @$progressElem = $(@el).find('.BCK-progress-container')
      @$statusLinkElem = $(@el).find('.BCK-status-link-container')
      @$downloadLinkElem = $(@el).find('.BCK-download-link-container')
      @menuView = arguments[0].menu_view
      @renderDownloadState()

    renderDownloadState: ->

      state = @model.getState()

      if state == glados.models.ServerSideDownloads.DownloadModel.states.INITIAL_STATE
        @hideAll()
      else if state == glados.models.ServerSideDownloads.DownloadModel.states.ERROR_STATE
        @renderWhenError()
      else if state == glados.models.ServerSideDownloads.DownloadModel.states.GENERATING_DOWNLOAD
        @renderWhenGeneratingDownload()
      else if state == glados.models.ServerSideDownloads.DownloadModel.states.DELETING
        @renderWhenGeneratingDownload()
      else if state == glados.models.ServerSideDownloads.DownloadModel.states.FINISHED
        @renderWhenFinished()

    hideAll: ->

      @$errorElem.hide()
      @$progressElem.hide()
      @$statusLinkElem.hide()
      @$downloadLinkElem.hide()

    #-------------------------------------------------------------------------------------------------------------------
    # Render when error
    #-------------------------------------------------------------------------------------------------------------------
    renderWhenError: ->

      errorReason = @model.get('error_msg')
      if errorReason?
        errorText = ": #{@model.get('error_msg')}"
      else
        errorText = ''
      errorParams =
        msg: "There was an error#{errorText}. Please try again later."
      glados.Utils.ErrorMessages.fillErrorForElement(@$errorElem, errorParams)

      @showErrorHideOthers()
      @menuView.enableDownloadButtons()

    showErrorHideOthers: ->

      @$errorElem.show()
      @$progressElem.hide()
      @$statusLinkElem.hide()
      @$downloadLinkElem.hide()


    #-------------------------------------------------------------------------------------------------------------------
    # Render when generating download
    #-------------------------------------------------------------------------------------------------------------------
    renderWhenGeneratingDownload: ->

      state = @model.getState()
      # just in case this is called from the callback while in a different state.
      if state not in [glados.models.ServerSideDownloads.DownloadModel.states.GENERATING_DOWNLOAD,
        glados.models.ServerSideDownloads.DownloadModel.states.DELETING]
        return

      if state == glados.models.ServerSideDownloads.DownloadModel.states.GENERATING_DOWNLOAD
        progressMsg = 'Generating Download File'
      else if state == glados.models.ServerSideDownloads.DownloadModel.states.DELETING
        progressMsg = 'Waiting for server cleanup'

      progressPercentage = @model.get('progress')
      paramsObj =
        msg: progressMsg
        percentage: progressPercentage
      glados.Utils.fillContentForElement(@$progressElem, paramsObj)

      progressURL = @model.getProgressURL()
      paramsObj =
        url: progressURL
      glados.Utils.fillContentForElement(@$statusLinkElem, paramsObj)
      @showProgressAndStatusLink()

    showProgressAndStatusLink: ->

      @$errorElem.hide()
      @$progressElem.show()
      @$statusLinkElem.show()
      @$downloadLinkElem.hide()

    #-------------------------------------------------------------------------------------------------------------------
    # Render when finished
    #-------------------------------------------------------------------------------------------------------------------
    renderWhenFinished: ->

      paramsObj =
        url: @model.getDownloadURL()
        expires: @model.get('expires')
      glados.Utils.fillContentForElement(@$downloadLinkElem, paramsObj)
      @showProgressAndStatusLink()
      @showDownloadLinkHideOthers()
      @menuView.enableDownloadButtons()

    showDownloadLinkHideOthers: ->
      @$errorElem.hide()
      @$progressElem.hide()
      @$statusLinkElem.hide()
      @$downloadLinkElem.show()




