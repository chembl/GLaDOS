class BreadcrumbApp

  @init = ->
    console.log 'INIT BREADCRUMB APP'
    current_url = document.URL
    url_slices = current_url.split '/'
#      console.log 'url_slices ', url_slices

    breadCrumbs = glados.models.base.Breadcrumb

    console.log 'breadCrumbs: ', breadCrumbs