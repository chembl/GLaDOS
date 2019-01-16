glados.useNameSpace 'glados.views.base',
  TrackView:

    initTracking: (viewName) ->
      console.log 'initTracking: ', viewName
      $(@el).click @generateClickTracker(viewName)

    generateClickTracker: (viewName) ->

      return ->

        paramsDict =
          view_name: viewName

        console.log 'register usage: ', viewName
        registerUsage = glados.doCSRFPost(glados.Settings.REGISTER_USAGE_ENDPOINT, paramsDict)
        registerUsage.then (data) -> console.debug "usage for #{viewName} registered"
        registerUsage.fail (data) -> console.debug "usage registration for #{viewName} failed!"