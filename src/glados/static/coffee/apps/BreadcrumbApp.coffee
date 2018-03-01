class BreadcrumbApp

  @init = ->
    console.log 'INIIIIT BREADCRUMB APP'
    current_url = document.URL
    url_slices = current_url.split '/'
#      console.log 'url_slices ', url_slices