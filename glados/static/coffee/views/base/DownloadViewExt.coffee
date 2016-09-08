DownloadViewExt =

  events:
    'click .BCK-trigger-download-JSON': 'triggerDownloadJSON'
    'click .BCK-trigger-download-CSV': 'triggerDownloadCSV'

  download: ->
    @model.download()

  showDownloadOptions: ->
    console.log 'show options'

  triggerDownloadJSON: ->
    @model.downloadJSON()

  triggerDownloadCSV: ->
    @model.downloadCSV()