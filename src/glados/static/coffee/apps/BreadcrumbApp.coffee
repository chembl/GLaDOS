glados.useNameSpace 'glados.apps',
  BreadcrumbApp: class BreadcrumbApp

    @setBreadCrumb = ->

      breadcrumbs = glados.models.Breadcrumb.BreadcrumbModel.getInstance()
      # make sure that the view exists
      glados.views.Breadcrumb.BreadcrumbsView.getInstance()
