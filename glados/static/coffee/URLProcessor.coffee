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

  # Tells whether or not the url is at the search results page
  # the url is expected to be search_results/:query_string\/?$
  @isAtSearchResultsPage = ->

    url_path = window.location.pathname;
    pattern = new RegExp( '^'+Settings.SEARCH_RESULTS_PAGE+'\/(.*?)\/?$')
    match = pattern.exec(url_path)
    if match
      return true
    return false

  # gets the query string for the search results page
  # the url is expected to be search_results/:query_string\/?$
  @getSearchQueryString = ->

    url_path = window.location.pathname;
    pattern = new RegExp( '^'+Settings.SEARCH_RESULTS_PAGE+'\/(.*?)\/?$')
    match = pattern.exec(url_path)
    if match and match.length > 1
      return match[1]
    return ""