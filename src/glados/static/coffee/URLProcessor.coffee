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
  # Search Results URL's
  # --------------------------------------------------------------------------------------------------------------------


  # Tells whether or not the url is at the search results page
  @isAtSearchResultsPage = (url_path)->
    if _.isUndefined(url_path)
      url_path = window.location.pathname;
    pattern = glados.Settings.SEARCH_RESULT_URL_REGEXP
    match = pattern.exec(url_path)
    if match
      return true
    return false

  # Tells whether or not the url is at the search results page with advanced filters
  @getSpecificSearchResultsPage = (url_path)->
    if _.isUndefined(url_path)
      url_path = window.location.pathname;
    pattern = glados.Settings.SEARCH_RESULT_URL_REGEXP
    match = pattern.exec(url_path)
    if match and match.length > 3 and match[1]
      return match[1]
    else
      return null

  # Tells whether or not the url is at the search results page with advanced filters
  @isAtAdvancedSearchResultsPage = (url_path)->
    if _.isUndefined(url_path)
      url_path = window.location.pathname;
    pattern = glados.Settings.SEARCH_RESULT_URL_REGEXP
    match = pattern.exec(url_path)
    return match and match.length > 3 and match[2] == '/'+glados.Settings.SEARCH_RESULTS_PAGE_ADVANCED_PATH

  # gets the query string for the search results page
  @getSearchQueryString = (url_path)->
    if _.isUndefined(url_path)
      url_path = window.location.pathname;
    pattern = glados.Settings.SEARCH_RESULT_URL_REGEXP
    match = pattern.exec(url_path)
    if match and match.length > 3
      # todo add more?
      if match[3] == 'GLaDOS'
        $('body').css('background-image', 'url("' + glados.Settings.STATIC_IMAGES_URL + 'GLaDOS-ProfilePic.png")')
        alert('Believe me, I am still alive!')

      return match[3]
    return ""

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