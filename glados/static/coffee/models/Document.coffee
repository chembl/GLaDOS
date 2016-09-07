Document = Backbone.Model.extend

  download: ->

    jsonContent = JSON.stringify(@toJSON())
    blob = new Blob([jsonContent], type: 'text/plain;charset=utf-8')
    saveAs blob, @get('document_chembl_id') + 'DocumentBasicInformation.txt'