class SearchResultsApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = (selectedESEntity, searchTerm, currentState) ->
    @eSQueryExplainView = new glados.views.SearchResults.ESQueryExplainView
      el: $('#es-query-explain-wrapper')

    $searchResultsContainer = $('.BCK-SearchResultsContainer')
    new glados.views.SearchResults.SearchResultsView
      el: $searchResultsContainer
      model: SearchModel.getInstance()
      attributes:
        selectedESEntity: selectedESEntity
        state: currentState

    stateObject = if currentState? then JSON.parse(atob(currentState)) else undefined
    SearchModel.getInstance().search(searchTerm, selectedESEntity, stateObject)

  @initSSSearchResults = (searchParams, searchType) ->

    GlobalVariables.SEARCH_TERM = searchParams.search_term

    ssSearchModel = new glados.models.Search.StructureSearchModel
      query_params: searchParams
      search_type: searchType

    console.log 'ssSearchModel: ', ssSearchModel

    $queryContainer = $('.BCK-query-Container')
    if searchType == glados.models.Search.StructureSearchModel.SEARCH_TYPES.SEQUENCE.BLAST
      @initSequenceQueryView($queryContainer, ssSearchModel)
    else
      @initStructureQueryView($queryContainer, ssSearchModel)


    $browserContainer = $('.BCK-BrowserContainer')
    $browserContainer.hide()
    $noResultsDiv = $('.no-results-found')

    listConfig = @getListConfig(searchType)
    console.log 'listConfig: ', listConfig

    thisApp = @
    ssSearchModel.once glados.models.Search.StructureSearchModel.EVENTS.RESULTS_READY, ->

      $browserContainer.show()
      thisApp.initBrowserFromSSResults($browserContainer, $noResultsDiv, listConfig, ssSearchModel)

    ssSearchModel.submitSearch()

  @initSequenceQueryView = ($queryContainer, ssSearchModel) ->

    console.log 'init sequence query view'
    new glados.views.SearchResults.SequenceQueryView
      el: $queryContainer
      model: ssSearchModel

  @initStructureQueryView = ($queryContainer, ssSearchModel) ->

    new glados.views.SearchResults.StructureQueryView
      el: $queryContainer
      model: ssSearchModel

  # --------------------------------------------------------------------------------------------------------------------
  # List Config
  # --------------------------------------------------------------------------------------------------------------------
  @getListConfig = (searchType) ->

    if searchType == glados.models.Search.StructureSearchModel.SEARCH_TYPES.STRUCTURE.SIMILARITY

      listConfig = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_SIMILARITY_MAPS

    else if searchType == glados.models.Search.StructureSearchModel.SEARCH_TYPES.STRUCTURE.SUBSTRUCTURE or \
    searchType == glados.models.Search.StructureSearchModel.SEARCH_TYPES.STRUCTURE.CONNECTIVITY

      listConfig = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.SUBSTRUCTURE_RESULTS_LIST

    else if searchType == glados.models.Search.StructureSearchModel.SEARCH_TYPES.SEQUENCE.BLAST

      listConfig = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.TARGET_BLAST_RESULTS

    return listConfig

  # --------------------------------------------------------------------------------------------------------------------
  # Router functions
  # --------------------------------------------------------------------------------------------------------------------
  @initSubstructureSearchResults = (searchTerm) ->

    searchParams =
      search_term: searchTerm

    @initSSSearchResults(searchParams, glados.models.Search.StructureSearchModel.SEARCH_TYPES.STRUCTURE.SUBSTRUCTURE)


  @initSimilaritySearchResults = (searchTerm, threshold) ->

    searchParams =
      search_term: searchTerm
      threshold: threshold

    @initSSSearchResults(searchParams, glados.models.Search.StructureSearchModel.SEARCH_TYPES.STRUCTURE.SIMILARITY)


  @initFlexmatchSearchResults = (searchTerm) ->

    searchParams =
      search_term: searchTerm

    @initSSSearchResults(searchParams, glados.models.Search.StructureSearchModel.SEARCH_TYPES.STRUCTURE.CONNECTIVITY)

  @initBLASTSearchResults = (base64Params) ->

    searchParams = {
      'alignments': '50',
      'database': 'chembl',
      'gapopen': '-1',
      'gapalign': 'true',
      'scores': '50',
      'sequence': '>sp|P35858|ALS_HUMAN Insulin-like growth factor-binding protein complex acid labile subunit OS=Homo sapiens GN=IGFALS PE=1 SV=1 \nMALRKGGLALALLLLSWVALGPRSLEGADPGTPGEAEGPACPAACVCSYDDDADELSVFC\nSSRNLTRLPDGVPGGTQALWLDGNNLSSVPPAAFQNLSSLGFLNLQGGQLGSLEPQALLG\nLENLCHLHLERNQLRSLALGTFAHTPALASLGLSNNRLSRLEDGLFEGLGSLWDLNLGWN\nSLAVLPDAAFRGLGSLRELVLAGNRLAYLQPALFSGLAELRELDLSRNALRAIKANVFVQ\nLPRLQKLYLDRNLIAAVAPGAFLGLKALRWLDLSHNRVAGLLEDTFPGLLGLRVLRLSHN\nAIASLRPRTFKDLHFLEELQLGHNRIRQLAERSFEGLGQLEVLTLDHNQLQEVKAGAFLG\nLTNVAVMNLSGNCLRNLPEQVFRGLGKLHSLHLEGSCLGRIRPHTFTGLSGLRRLFLKDN\nGLVGIEEQSLWGLAELLELDLTSNQLTHLPHRLFQGLGKLEYLLLSRNRLAELPADALGP\nLQRAFWLDVSHNRLEALPNSLLAPLGRLRYLSLRNNSLRTFTPQPPGLERLWLEGNPWDC\nGCPLKALRDFALQNPSAVPRFVQAICEGDDCQPPAYTYNNITCASPPEVVGLDLRDLSEA\nHFAPC\n',
#      'sequence': 'blablablbalbal'
      'matrix': 'BLOSUM62',
      'dropoff': '0',
      'email': 'dmendez@ebi.ac.uk',
      'align': '0',
      'transltable': '1',
      'gapext': '-1',
      'program': 'blastp',
      'stype': 'protein',
      'filter': 'F',
      'task': 'blastp',
      'exp': '10',
      'compstats': 'F'
    }

    console.log 'searchParams: ', searchParams
    return
    @initSSSearchResults(searchParams, glados.models.Search.StructureSearchModel.SEARCH_TYPES.SEQUENCE.BLAST)


  @initBrowserFromSSResults = ($browserContainer, $noResultsDiv, customSettings, ssSearchModel) ->

    resultIds = ssSearchModel.get('result_ids')
    esCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(
      customQuery=undefined, itemsList=resultIds, settings=customSettings, ssSearchModel)

    new glados.views.Browsers.BrowserMenuView
      collection: esCompoundsList
      el: $browserContainer

    esCompoundsList.fetch()