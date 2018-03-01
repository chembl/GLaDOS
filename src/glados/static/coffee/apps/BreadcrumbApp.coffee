class BreadcrumbApp

  @init = ->
    console.log 'INIT BREADCRUMB APP'

    breadCrumbs = glados.models.base.Breadcrumb

    console.log 'Breadcrumbs: ', breadCrumbs