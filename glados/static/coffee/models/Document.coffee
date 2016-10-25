Document = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  initialize: ->

    @url = Settings.WS_BASE_URL + 'document/' + @get('document_chembl_id') + '.json'


