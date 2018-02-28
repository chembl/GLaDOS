glados.useNameSpace 'glados.apps.Browsers',
  BrowserRouter: Backbone.Router.extend
    routes:
      ':entity_name(/filter/:filter)(/state/:state)': 'initBrowser'

    initBrowser: (entityName, filter, state) ->
      glados.apps.Browsers.BrowserApp.initBrowserForEntity(entityName, filter, state)

