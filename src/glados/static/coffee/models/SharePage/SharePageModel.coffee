glados.useNameSpace 'glados.models.SharePage',

  # This model handles the communication with the server for structure searches
  SharePageModel: Backbone.Model.extend

    initialize: ->

      console.log 'init Share page Model'
      console.log @get('long_url')