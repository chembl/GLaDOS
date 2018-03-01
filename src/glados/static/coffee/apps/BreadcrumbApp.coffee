glados.useNameSpace 'glados.apps',
  BreadcrumbApp: class BreadcrumbApp

    @init = ->
      breadCrumbs = new glados.models.base.Breadcrumb.Breadcrumb
    #    breadCrumbs.fetch()

      console.log 'Breadcrumbs: ', breadCrumbs