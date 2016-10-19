class VisualComponentsSummaryApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------
  @init = ->

    # compound 3d view
    sampleCompound = new Compound({molecule_chembl_id: 'CHEMBL1163143'})
    VisualComponentsSummaryApp.sampleCompound = sampleCompound
    VisualComponentsSummaryApp.initSampleCompound3DView($('#BCK-compound-3dview'))
    sampleCompound.fetch()

    # document assay network
    documentAssayNetwork = new DocumentAssayNetwork({document_chembl_id: 'CHEMBL1151960'})
    VisualComponentsSummaryApp.sampleDocumentAssayNetwork = documentAssayNetwork
    VisualComponentsSummaryApp.initSampleDANView( $('#DAssayNetworkCard'))
    documentAssayNetwork.fetch()


  # --------------------------------------------------------------------------------------------------------------------
  # Models
  # --------------------------------------------------------------------------------------------------------------------


  # --------------------------------------------------------------------------------------------------------------------
  # Views
  # --------------------------------------------------------------------------------------------------------------------

  # this initialises the view that handles the 3d visualisation of a compound
  @initSampleCompound3DView = ($elem) ->

    comp3DView = new Compound3DView
      el: $elem,
      model: VisualComponentsSummaryApp.sampleCompound,
      type: 'reduced'


  @initSampleDANView = ($elem) ->

    danView = new DocumentAssayNetworkView
      el: $elem
      model: VisualComponentsSummaryApp.sampleDocumentAssayNetwork

    return danView

