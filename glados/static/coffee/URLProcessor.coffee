class URLProcessor

  # this gets the chembl_id from the url in the page
  # it expects the url to be .*\/CHEMBL1151960\/$
  @getRequestedChemblID = ->

    pathname = window.location.pathname;
    pathnameParts = pathname.split('/')
    return pathnameParts[pathnameParts.length - 2]