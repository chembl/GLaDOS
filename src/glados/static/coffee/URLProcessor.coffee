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

  # Tells whether or not the url is at the search results page
  @isAtSearchResultsPage = ->

    url_path = window.location.pathname;
    pattern = glados.Settings.SEARCH_RESULT_URL_REGEXP
    match = pattern.exec(url_path)
    if match
      return true
    return false

  # Tells whether or not the url is at the search results page with advanced filters
  @isAtAdvancedSearchResultsPage = ->

    url_path = window.location.pathname;
    pattern = glados.Settings.SEARCH_RESULT_URL_REGEXP
    match = pattern.exec(url_path)
    return match and match.length > 2 and match[1] == '/'+glados.Settings.SEARCH_RESULTS_PAGE_ADVANCED_PATH

  # gets the query string for the search results page
  @getSearchQueryString = ->

    url_path = window.location.pathname;
    pattern = glados.Settings.SEARCH_RESULT_URL_REGEXP
    match = pattern.exec(url_path)
    if match and match.length > 2
      return match[2]
    return ""

  # gets the query string for the substructure search results page
  @getSubstructureSearchQueryString = ->

    pathname = window.location.pathname
    pathnameParts = pathname.split('/')
    return pathnameParts[pathnameParts.length - 1]

  # gets the query string for the substructure search results page
  @getSimilaritySearchQueryString = ->

    pathname = window.location.pathname
    pathnameParts = pathname.split('/')
    return pathnameParts[pathnameParts.length - 2]

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
    return pathnameParts[pathnameParts.length - position - 1]