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

  # --------------------------------------------------------------------------------------------------------------------
  # Paginated Collections filters
  # --------------------------------------------------------------------------------------------------------------------

  @getFilter = ->
    filterWord = '/filter/'
    pathname = window.location.pathname
    filter = pathname.split(filterWord)[1]
    return if filter? then decodeURIComponent(filter) else undefined

  # --------------------------------------------------------------------------------------------------------------------
  # Structure Search URL's
  # --------------------------------------------------------------------------------------------------------------------

  # gets the query string for the substructure search results page
  @getSubstructureSearchQueryString = ->

    pathname = window.location.pathname
    pathnameParts = pathname.split('/')
    return decodeURIComponent pathnameParts[pathnameParts.length - 1]

  # gets the query string for the substructure search results page
  @getSimilaritySearchQueryString = ->

    pathname = window.location.pathname
    pathnameParts = pathname.split('/')
    return decodeURIComponent pathnameParts[pathnameParts.length - 2]

  # gets the query string for the substructure search results page
  @getSimilaritySearchPercentage = ->

    pathname = window.location.pathname
    pathnameParts = pathname.split('/')
    return parseInt( pathnameParts[pathnameParts.length - 1])

  # gets the sting in a specific position in the url after separating by '/'
  # position starts at 0
  @getUrlPartInReversePosition = (position) ->

    pathname = window.location.pathname
    pathnameParts = pathname.split('/')
    return decodeURIComponent pathnameParts[pathnameParts.length - position - 1]