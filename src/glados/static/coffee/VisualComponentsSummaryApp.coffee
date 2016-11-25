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

    #browse as table.
    sampleDrugList = new DrugList({})
    VisualComponentsSummaryApp.sampleDrugList = sampleDrugList
    VisualComponentsSummaryApp.initSampleBrowserAsTableInCardView($('#BCK-BrowserAsTable'))
    sampleDrugList.fetch({reset: true})

    #browse as Card pages
    compResListAsCardView = VisualComponentsSummaryApp.initCSampleBrowserAsCPinCardView($('#BCK-ResultsCardPages'));


  # --------------------------------------------------------------------------------------------------------------------
  # Models
  # --------------------------------------------------------------------------------------------------------------------


  # --------------------------------------------------------------------------------------------------------------------
  # Views
  # --------------------------------------------------------------------------------------------------------------------

  # this initialises the view that handles the 3d visualisation of a compound
  @initSampleCompound3DView = ($elem) ->

    comp3DView = new Compound3DViewSpeck
      el: $elem,
      model: VisualComponentsSummaryApp.sampleCompound,
      type: 'reduced'


  @initSampleDANView = ($elem) ->

    danView = new DocumentAssayNetworkView
      el: $elem
      model: VisualComponentsSummaryApp.sampleDocumentAssayNetwork

    return danView

   # This initialises the view of the broswer as a table inside a card that is embeddable,
  # and has all the characteristics of a card view.
  @initSampleBrowserAsTableInCardView = ($elem) ->

    asTableInCardView = new DrugBrowserTableAsCardView
      collection: VisualComponentsSummaryApp.sampleDrugList
      el: $elem

    return asTableInCardView

  # This initialises the view that shows a sample of a card pages browser, embedded as card
  @initCSampleBrowserAsCPinCardView = ($elem) ->

    view = new CompoundResultsListAsCardView
      collection: VisualComponentsSummaryApp.sampleDrugList
      el: $elem

    return view

