class URLProcessor

  # this gets the chembl_id from the url in the page
  # it expects the url to be .*\/CHEMBL1151960\/$
  @getRequestedChemblID = ->

    pathname = window.location.pathname
    pathnameParts = pathname.split('/')
    return pathnameParts[pathnameParts.length - 2]

  # this gets the chembl_id from the url in the page
  # it expects the url to be .*\/CHEMBL1151960\/embed\/.*\/$
  @getRequestedChemblIDWhenEmbedded = ->

    pathname = window.location.pathname;
    pathnameParts = pathname.split('/')
    return pathnameParts[pathnameParts.length - 4]

  # this gets the search terms from the url to search for documents with those terms
  @getEncodedSearchTemsForDocuments = ->

    pathname = window.location.pathname;
    pathnameParts = pathname.split('/')

    return pathnameParts[2]
