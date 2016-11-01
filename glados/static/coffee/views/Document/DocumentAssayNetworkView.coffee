# View that renders the Document assay network section
# from the Document report card
# load CardView first!
# also make sure the html can access the handlebars templates!
DocumentAssayNetworkView = CardView.extend(ResponsiviseViewExt).extend(DANViewExt).extend(DownloadViewExt).extend

  initialize: ->

    #ResponsiviseViewExt
    @$vis_elem = $('#AssayNetworkVisualisationContainer')
    updateViewProxy = @setUpResponsiveRender()
    @model.on 'change', updateViewProxy, @
    @resource_type = 'Document'

  render: ->

    @showCardContent()
    @hideResponsiveViewPreloader()
    @addFSLinkAndInfo()
    @paintMatrix()

    @initEmbedModal('assay_network')
    @activateModals()


  addFSLinkAndInfo: ->

    $(@el).find('.fullscreen-link').html Handlebars.compile( $('#Handlebars-Document-DAN-FullScreenLink').html() )
      chembl_id: @model.get('document_chembl_id')

    $(@el).find('.num-results').html Handlebars.compile( $('#Handlebars-Document-DAN-NumResults').html() )
      num_results: @model.get('graph').nodes.length

  # --------------------------------------------------------------------
  # Downloads
  # --------------------------------------------------------------------

  getFilename: (format) ->

    if format == 'csv'
      return @model.get('document_chembl_id') + 'DocumentAssayNetwork.csv'
    else if format == 'json'
      return @model.get('document_chembl_id') + 'DocumentAssayNetwork.json'
    else if format == 'xlsx'
      return @model.get('document_chembl_id') + 'DocumentAssayNetwork.xlsx'
    else
      return 'file.txt'