glados.useNameSpace 'glados.apps.Browsers',
  BrowserRouter: Backbone.Router.extend
    routes:
      ':entity_name(/filter/:filter)': 'initBrowser'

    initBrowser: (entityName, filter) -> glados.apps.Browsers.BrowserApp.initBrowserForEntity(entityName, filter)

