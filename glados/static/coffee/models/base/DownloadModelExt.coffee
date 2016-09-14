DownloadModelExt =

  getBlobToDownload: (contentStr) ->

    return new Blob([contentStr], type: 'text/plain;charset=utf-8')

  # This function returns the object that is going to be used to
  # generate the download, if there is no special download parser
  # function, the object will be simply the object's attributes
  getDownloadObject: (downloadParserFunction) ->

    if !downloadParserFunction?
      return @attributes
    else
      return downloadParserFunction @attributes

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

    downloadObject = @getDownloadObject(downloadParserFunction)

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

    downloadObject = @getDownloadObject(downloadParserFunction)

    blob = @getBlobToDownload @getJSONString(downloadObject)
    saveAs blob, filename

  # --------------------------------------------------------------------
  # xls
  # --------------------------------------------------------------------

  getXLSString: (downloadObject) ->

    return 'XLSX'


  downloadXLS: (filename, downloadParserFunction) ->

    downloadObject = @getDownloadObject(downloadParserFunction)

    blob = @getBlobToDownload @getXLSString(downloadObject)
    saveAs blob, filename

