glados.useNameSpace 'glados.apps',
  BreadcrumbApp: class BreadcrumbApp

    @init = ->
      breadcrumbs = new glados.models.base.Breadcrumb.Breadcrumb

      new glados.views.base.BreadcrumbsView
        el: $('#BCK-breadcrumbs')
        model: breadcrumbs
        
#      breadCrumbs.fetch()

      console.log 'breadcrumbs: ', breadcrumbs