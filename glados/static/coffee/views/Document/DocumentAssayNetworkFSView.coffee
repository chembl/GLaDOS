# View that renders the Document assay in fullscreen mode
# load CardView first!
# also make sure the html can access the handlebars templates!
DocumentAssayNetworkFSView = Backbone.View.extend(ResponsiviseViewExt).extend(DANViewExt).extend(DownloadViewExt).extend

  initialize: ->

    $(@el).find('select').material_select();

    @$vis_elem = $('#AssayNetworkVisualisationFSContainer')
    updateViewProxy = @setUpResponsiveRender()
    @model.on 'change', updateViewProxy, @

  render: ->

    console.log 'render!'

    $(@el).find('.vis-title').html Handlebars.compile( $('#Handlebars-Document-DAN-FS-title').html() )
      chembl_id: @model.get('document_chembl_id')

    @hideResponsiveViewPreloader()
    @paintMatrix()

  # --------------------------------------------------------------------
  # Downloads
  # --------------------------------------------------------------------

  getFilename: (format) ->

    if format == 'csv'
      return @model.get('document_chembl_id') + 'DocumentAssayNetwork.csv'
    else if format == 'json'
      return @model.get('document_chembl_id') + 'DocumentAssayNetwork.json'
    else
      return 'file.txt'


