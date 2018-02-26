glados.useNameSpace 'glados.apps.Browsers',
  BrowserRouter: Backbone.Router.extend
    routes:
      ':entity_name': 'initBrowser'

    initBrowser: (entityName) -> glados.apps.Browsers.BrowserApp.initBrowserForEntity(entityName)

