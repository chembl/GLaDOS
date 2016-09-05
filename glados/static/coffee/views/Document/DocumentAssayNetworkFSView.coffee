# View that renders the Document assay network section
# from the Document report card
# load CardView first!
# also make sure the html can access the handlebars templates!
DocumentAssayNetworkFSView = Backbone.View.extend(ResponsiviseViewExt).extend(DANViewExt).extend

  initialize: ->

    $(@el).find('select').material_select();

    @$vis_elem = $('#AssayNetworkVisualisationFSContainer')
    updateViewProxy = @setUpResponsiveRender()
    @model.on 'change', updateViewProxy, @

  render: ->

    console.log 'render!'

    $(@el).find('.vis-title').html Handlebars.compile( $('#Handlebars-Document-DAN-FS-title').html() )
      chembl_id: @model.get('document_chembl_id')

    @hidePreloader()
    @paintMatrix()


