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
  @isAtSearchResultsPage = ->

    url_path = window.location.pathname;
    pattern = Settings.SEARCH_RESULT_URL_REGEXP
    match = pattern.exec(url_path)
    if match
      return true
    return false

  # Tells whether or not the url is at the search results page with advanced filters
  @isAtAdvancedSearchResultsPage = ->

    url_path = window.location.pathname;
    pattern = Settings.SEARCH_RESULT_URL_REGEXP
    match = pattern.exec(url_path)
    return match and match.length > 2 and match[1] == '/'+Settings.SEARCH_RESULTS_PAGE_ADVANCED_PATH

  # gets the query string for the search results page
  @getSearchQueryString = ->

    url_path = window.location.pathname;
    pattern = Settings.SEARCH_RESULT_URL_REGEXP
    match = pattern.exec(url_path)
    if match and match.length > 2
      return match[2]
    return ""