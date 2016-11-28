class DocumentSearchByTermsApp

  # -------------------------------------------------------------
  # Initialization
  # -------------------------------------------------------------
  @init = ->

    GlobalVariables.SEARCH_TERM = URLProcessor.getEncodedSearchTemsForDocuments()
    GlobalVariables.SEARCH_TERM_DECODED = decodeURI GlobalVariables.SEARCH_TERM

    docsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewDocumentsFromTermsList()
    docsList.initUrl(GlobalVariables.SEARCH_TERM)

    docResView = new DocumentsFromTermsView
      collection: docsList
      el: $('#BCK-DocsWithTermResults')

    docsList.fetch()