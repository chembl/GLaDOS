DownloadModelExt =

  getBlobToDownload: (contentStr) ->

    return new Blob([contentStr], type: 'text/plain;charset=utf-8')

  # --------------------------------------------------------------------
  # CSV
  # --------------------------------------------------------------------

  getCSVHeaderString: (downloadObject) ->

    keys = []
    for key, value of downloadObject
      keys.push(key)

    return keys.join(';')

  getCSVContentString: (downloadObject) ->

    values = []
    for key, value of downloadObject
      values.push(JSON.stringify(downloadObject[key]))

    return values.join(';')

  getFullCSVString: (downloadObject) ->

    header = @getCSVHeaderString(downloadObject)
    content = @getCSVContentString(downloadObject)
    return header + '\n' + content

  downloadCSV: (filename, downloadParserFunction) ->

    if !downloadParserFunction?
      downloadObject = @attributes
    else
      downloadObject = downloadParserFunction @attributes

    blob = @getBlobToDownload @getFullCSVString(downloadObject)
    saveAs blob, filename

  # --------------------------------------------------------------------
  # json
  # --------------------------------------------------------------------

  getJSONString: (downloadObject) ->

    JSON.stringify(downloadObject)


  # the download parser function determines what to to with the model's
  # attributes to generate the object that is going to be used for
  # generating the download.
  downloadJSON: (filename, downloadParserFunction) ->

    if !downloadParserFunction?
      downloadObject = @attributes
    else
      downloadObject = downloadParserFunction @attributes

    blob = @getBlobToDownload @getJSONString(downloadObject)
    saveAs blob, filename

