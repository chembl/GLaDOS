DownloadViewExt =

  events:
    'click .BCK-trigger-download-JSON': 'triggerDownloadJSON'
    'click .BCK-trigger-download-CSV': 'triggerDownloadCSV'
    'click .BCK-trigger-download-XLS': 'triggerDownloadXLS'

  showDownloadOptions: ->
    console.log 'show options'

  triggerDownloadJSON: ->

    @modelOrCollection = if @model? then @model else @collection
    #remember that downloadParserFunction can be null if you just want to use all the attributes for the download.
    @modelOrCollection.downloadJSON(@getFilename('json'), @downloadParserFunction)

  triggerDownloadCSV: ->

    @modelOrCollection = if @model? then @model else @collection
    @modelOrCollection.downloadCSV(@getFilename('csv'), @downloadParserFunction)

  triggerDownloadXLS: ->

    @modelOrCollection = if @model? then @model else @collection
    @modelOrCollection.downloadXLS(@getFilename('xlsx'), @downloadParserFunction)

  # overrride this function in your view to get your desired functionality
  getFilename: (format) ->

    return 'file.txt'