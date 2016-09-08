DownloadModelExt =

  getBlobToDownload: (contentStr) ->

    return new Blob([contentStr], type: 'text/plain;charset=utf-8')

  # --------------------------------------------------------------------
  # CSV
  # --------------------------------------------------------------------

  getCSVHeaderString: ->

    keys = []
    for key, value of @attributes
      keys.push(key)

    return keys.join(';')

  getCSVContentString: ->

    values = []
    for key, value of @attributes
      values.push(JSON.stringify(@attributes[key]))

    return values.join(';')

  getFullCSVString: ->

    header = @getCSVHeaderString()
    content = @getCSVContentString()
    return header + '\n' + content

  downloadCSV: (filename) ->

    blob = @getBlobToDownload @getFullCSVString()
    saveAs blob, filename

  # --------------------------------------------------------------------
  # json
  # --------------------------------------------------------------------

  getJSONString: ->

    JSON.stringify(@toJSON())

  downloadJSON: (filename) ->

    blob = @getBlobToDownload @getJSONString()
    saveAs blob, filename