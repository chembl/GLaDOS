# View that renders the Document assay network section
# from the Document report card
# load CardView first!
# also make sure the html can access the handlebars templates!
DocumentAssayNetworkView = CardView.extend(ResponsiviseViewExt).extend(DANViewExt).extend(DownloadViewExt).extend

  initialize: ->

    @$vis_elem = $('#AssayNetworkVisualisationContainer')
    updateViewProxy = @setUpResponsiveRender()

    @model.on 'change', updateViewProxy, @

    @csvFilename = @model.get('document_chembl_id') + 'DocumentAssayNetwork.csv'
    @jsonFilename = @model.get('document_chembl_id') + 'DocumentAssayNetwork.json'

  render: ->

    console.log('render!')

    @hidePreloader()
    @addFSLinkAndInfo()
    @paintMatrix()


  addFSLinkAndInfo: ->

    $(@el).find('.fullscreen-link').html Handlebars.compile( $('#Handlebars-Document-DAN-FullScreenLink').html() )
      chembl_id: @model.get('document_chembl_id')

    $(@el).find('.num-results').html Handlebars.compile( $('#Handlebars-Document-DAN-NumResults').html() )
      num_results: @model.get('graph').nodes.length