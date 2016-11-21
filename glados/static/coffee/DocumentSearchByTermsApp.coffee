class DocumentSearchByTermsApp

  # -------------------------------------------------------------
  # Initialization
  # -------------------------------------------------------------
  @init = ->

    GlobalVariables.SEARCH_TERM = URLProcessor.getEncodedSearchTemsForDocuments()
    GlobalVariables.SEARCH_TERM_DECODED = decodeURI GlobalVariables.SEARCH_TERM

    docsList = new DocumentsFromTermList
    docsList.initUrl(GlobalVariables.SEARCH_TERM)

    docResView = new DocumentsFromTermsView
      collection: docsList
      el: $('#BCK-DocsWithTermResults')

    console.log 'COLLECTION: ', docsList

    docsList.fetch()