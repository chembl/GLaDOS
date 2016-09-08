Document = Backbone.Model.extend

  getBlobToDownload: (contentStr) ->

    return new Blob([contentStr], type: 'text/plain;charset=utf-8')

  # --------------------------------------------------------------------
  # CSV
  # --------------------------------------------------------------------

  getCSVHeaderString: ->

    keys = []
    for key, value of @attributes
      keys.push(key)

    return keys.join(',')

  getCSVContentString: ->

    values = []
    for key, value of @attributes
      values.push(value)

    return values.join(',')

  getFullCSVString: ->

    header = @getCSVHeaderString()
    content = @getCSVContentString()
    return header + '\n' + content

  downloadCSV: ->

    blob = @getBlobToDownload @getFullCSVString()
    saveAs blob, @get('document_chembl_id') + 'DocumentBasicInformation.csv'

  # --------------------------------------------------------------------
  # json
  # --------------------------------------------------------------------

  getJSONString: ->

    JSON.stringify(@toJSON())

  downloadJSON: ->

    blob = @getBlobToDownload @getJSONString()
    saveAs blob, @get('document_chembl_id') + 'DocumentBasicInformation.json'


