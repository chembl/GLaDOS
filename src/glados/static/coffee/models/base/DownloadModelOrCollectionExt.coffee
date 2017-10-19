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

  getCSVHeaderString: (downloadObject, isTabSeparated) ->

    separator = if isTabSeparated then "\t" else ";"
    #use first object to get header
    keys = []
    for key, value of downloadObject[0]
      keys.push('"' + key + '"')

    return keys.join(separator)

  getCSVContentString: (downloadObject, isTabSeparated) ->

    separator = if isTabSeparated then "\t" else ";"

    rows = []
    for obj in downloadObject
      values = []
      for key, value of obj

        finalValue = obj[key]
        finalValue ?= glados.Settings.DEFAULT_NULL_VALUE_LABEL
        if _.isFunction(finalValue)
          finalValue = glados.Settings.DEFAULT_NULL_VALUE_LABEL
        finalValue = JSON.stringify(finalValue).replace(/"/g, '')

        values.push('"' + finalValue + '"')
      rows.push(values.join(separator))

    return rows.join('\n')

  getFullCSVString: (downloadObject, isTabSeparated) ->

    header = @getCSVHeaderString(downloadObject, isTabSeparated)
    content = @getCSVContentString(downloadObject, isTabSeparated)
    return header + '\n' + content

  # the downloadParserFunction is a function that knows what modifications to do for the raw json data
  # of the download. for example, if you only want the parent properties of a compound this is a function that
  # given the raw json, it returns the "molecule_properties" property only
  # if you want to use a json custom object without using the parser function schema, use customObject
  downloadCSV: (filename, downloadParserFunction, customObject, isTabSeparated) ->

    downloadObject = if customObject? then customObject else @getDownloadObject(downloadParserFunction)
    strContent = @getFullCSVString(downloadObject, isTabSeparated)
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

  # --------------------------------------------------------------------
  # General
  # --------------------------------------------------------------------
  # Generates a download from a plain string, which is the file contents
  downloadTextFile: (filename, strFileContent) ->

    blob = @getBlobToDownload strFileContent
    saveAs blob, filename
    return strFileContent

  # --------------------------------------------------------------------
  # SDF
  # --------------------------------------------------------------------
  #It generates a sdf file from a list of chembl ids, the progress element is to inform the progress to the user.
  generateSDFFromChemblIDs: (idsList, $progressElement) ->

    fullSDFString = ''
    totalItems = idsList.length
    chunkSize = 500
    totalPages = Math.ceil(totalItems / chunkSize)


    # this function paginates over the full list of ids to get the full sdf file from the list.
    # this needs to be done because of the maximum number of items that the web services return is 1000
    downloadSDF = (page) ->
      url = glados.Settings.WS_BASE_URL + 'molecule.sdf'
      start = (page - 1) * chunkSize
      end = start + chunkSize - 1
      if end >= idsList.length
        end = idsList.length - 1

      itemsToGet = idsList[start..end]

      data = 'limit=' + chunkSize + '&' + 'molecule_chembl_id__in=' + itemsToGet.join(',')

      $.ajax(
        type: 'POST'
        url: url
        data: data
        headers:
          'X-HTTP-Method-Override': 'GET'

      ).done( (response) ->

        fullSDFString += response

        percentage = Math.ceil((page / totalPages) * 100)

        if $progressElement?
          $progressElement.html Handlebars.compile( $('#Handlebars-Common-DownloadColMessages3').html() )
            percentage: percentage

        # check if I still have more pages to go
        if page < totalPages
          downloadSDF (page + 1)
        else
          # if not, I have finished! I can generate the download!
          DownloadModelOrCollectionExt.downloadTextFile('results.sdf', fullSDFString)

          if $progressElement?
            $progressElement.html Handlebars.compile( $('#Handlebars-Common-DownloadColMessages2').html() )
              num_compounds: (fullSDFString.match(new RegExp("CHEMBL", "g")) || []).length

            setTimeout( (()-> $progressElement.html ''), 2000)

      )

    # get everything from page 1
    downloadSDF 1