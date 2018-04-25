glados.useNameSpace 'glados.models.MainPage',
  EntitiesInfo: Backbone.Model.extend

    ERROR_LABEL: '(Error loading data)'
    initialize: -> @url = glados.Settings.WS_BASE_URL + 'status.json'