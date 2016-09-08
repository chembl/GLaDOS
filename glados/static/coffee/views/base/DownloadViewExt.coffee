DownloadViewExt =

  events:
    'click .BCK-trigger-download-JSON': 'triggerDownloadJSON'
    'click .BCK-trigger-download-CSV': 'triggerDownloadCSV'

  download: ->
    @model.download()

  showDownloadOptions: ->
    console.log 'show options'

  triggerDownloadJSON: ->
    #remember that downloadParserFunction can be null if you just want to use all the attributes for the download.
    @model.downloadJSON(@getFilename('json'), @downloadParserFunction)

  triggerDownloadCSV: ->
    @model.downloadCSV(@getFilename('csv'), @downloadParserFunction)

  # overrride this function in your view to get your desired functionality
  getFilename: (format) ->

    return 'file.txt'
