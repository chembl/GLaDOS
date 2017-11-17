glados.useNameSpace 'glados.apps.Activity',
  ActivitiesRouter: Backbone.Router.extend
    routes:
      '': 'initBrowser'
      'matrix_fs/:sourceEntity': 'initFullScreenMatrix'

    initBrowser: -> ActivitiesBrowserApp.initBrowser()
    initFullScreenMatrix: (sourceEntity) ->
      alert('init matrix from ' + sourceEntity)
