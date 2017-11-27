glados.useNameSpace 'glados.models.Compound',
  Metabolism: Backbone.Model.extend

    initialize: ->
      console.log 'URL: ', glados.Settings.ES_BASE_URL
      @url = glados.Settings.STATIC_URL + 'testData/metabolismSampleData.json'
