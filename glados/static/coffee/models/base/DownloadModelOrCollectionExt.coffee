DownloadModelOrCollectionExt =

  getBlobToDownload: (contentStr, contentType) ->

    contentType = 'text/plain;charset=utf-8' unless contentType?
    return new Blob([contentStr], type: contentType)

  # This function returns the object that is going to be used to
  # generate the download, The download object is a javascript object with the structure required from the download
  # for example, to download a compound, the download object will be something like:
  #
  # [{"molecule_chembl_id":"CHEMBL25",
  # "atc_classifications":["N02BA01","N02BA51","N02BA71","A01AD05","B01AC06"],
  # "availability_type":"2",
  # "biotherapeutic":null,
  # "black_box_warning":"0","chebi_par_id":15365,"chirality":"1",
  # ...}]
  # and the download functions will take care of handling it in order to generate the file
  #
  # IT IS ALWAYS A LIST OF OBJECTS
  # you can download only one item (one compound) or a list of items
  # (a list of compounds)
  #
  # [compA, compB, compC]
  # [{...}, {...}, {...}]
  # if there is no special download parser
  # function, the object will be a list of onw item consisting of the objects attributes or model list
  getDownloadObject: (downloadParserFunction) ->

    content = if @attributes? then @attributes else (m.attributes for m in @models)

    if !downloadParserFunction?
      if content instanceof Array
        return content
      else
        return [content]
    else
      return downloadParserFunction content

  # --------------------------------------------------------------------
  # CSV
  # --------------------------------------------------------------------

  getCSVHeaderString: (downloadObject) ->

    #use first object to get header
    keys = []
    for key, value of downloadObject[0]
      keys.push(key)

    return keys.join(';')

  getCSVContentString: (downloadObject) ->

    rows = []
    for obj in downloadObject
      values = []
      for key, value of obj
        values.push(JSON.stringify(obj[key]))
      rows.push(values.join(';'))

    return rows.join('\n')

  getFullCSVString: (downloadObject) ->

    header = @getCSVHeaderString(downloadObject)
    content = @getCSVContentString(downloadObject)
    return header + '\n' + content

  downloadCSV: (filename, downloadParserFunction) ->

    downloadObject = @getDownloadObject(downloadParserFunction)
    strContent = @getFullCSVString(downloadObject)
    blob = @getBlobToDownload strContent
    saveAs blob, filename

    return strContent

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
    strContent = @getJSONString(downloadObject)
    blob = @getBlobToDownload strContent
    saveAs blob, filename
    return strContent

  # --------------------------------------------------------------------
  # xls
  # --------------------------------------------------------------------

  getXLSString: (downloadObject) ->

    Workbook = ->
      if !(this instanceof Workbook)
        return new Workbook
      @SheetNames = []
      @Sheets = {}
      return

    wb = new Workbook()
    wb.SheetNames.push('sheet1')

    ws = {}

    # add header row from first object
    currentRow = 0
    currentColumn = 0
    for key, value of downloadObject[0]

      cellNumber = XLSX.utils.encode_cell({c:currentColumn, r:currentRow})
      cellContent = {v: key, t:'s' } # t is the type, for now everything is a string
      ws[cellNumber] = cellContent

      currentColumn++

    # add data rows
    rows = []
    for obj in downloadObject

      currentRow++
      currentColumn = 0
      for key, value of obj

        cellNumber = XLSX.utils.encode_cell({c:currentColumn, r:currentRow})
        if value?
         cellVal = value
        else
          cellVal = '---'

        cellContent = {v: String(cellVal), t:'s' }
        ws[cellNumber] = cellContent

        currentColumn++

    range = {s: {c:0, r:0}, e: {c:currentColumn - 1 , r:currentRow }}

    ws['!ref'] = XLSX.utils.encode_range(range)

    wb.Sheets['sheet1'] = ws


    wbout = XLSX.write(wb, {bookType:'xlsx', bookSST:true, type: 'binary'})

    s2ab = (s) ->
      buf = new ArrayBuffer(s.length)
      view = new Uint8Array(buf)
      i = 0
      while i != s.length
        view[i] = s.charCodeAt(i) & 0xFF
        ++i
      buf

    return s2ab(wbout)


  downloadXLS: (filename, downloadParserFunction) ->

    downloadObject = @getDownloadObject(downloadParserFunction)
    strContent = @getXLSString(downloadObject)

    blob = @getBlobToDownload strContent, 'application/octet-stream'
    saveAs blob, filename

    ab2s= (buf) ->
      String.fromCharCode.apply(null, new Uint8Array(buf));

    return ab2s(strContent)
