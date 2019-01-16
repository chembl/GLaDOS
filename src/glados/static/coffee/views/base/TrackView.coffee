glados.useNameSpace 'glados.views.base',
  TrackView:

    initTracking: (viewName) ->
      console.log 'initTracking: ', viewName
      $(@el).click @generateClickTracker(viewName)

    generateClickTracker: (viewName) ->

      return ->

        console.log 'CLICKED: ', viewName