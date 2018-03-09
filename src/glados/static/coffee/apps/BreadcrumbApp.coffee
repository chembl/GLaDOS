glados.useNameSpace 'glados.apps',
  BreadcrumbApp: class BreadcrumbApp

    @init = ->
      breadcrumbs = new glados.models.Breadcrumb.BreadcrumbModel

      new glados.views.Breadcrumb.BreadcrumbsView
        el: $('#BCK-breadcrumbs')
        model: breadcrumbs
