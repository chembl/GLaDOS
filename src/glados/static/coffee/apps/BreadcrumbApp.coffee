glados.useNameSpace 'glados.apps',
  BreadcrumbApp: class BreadcrumbApp

    @setBreadCrumb = (breadcrumbsList=[])->

      # make sure that the view exists
      glados.views.Breadcrumb.BreadcrumbsView.getInstance()

      breadcrumbs = glados.models.Breadcrumb.BreadcrumbModel.getInstance()
      breadcrumbs.set('breadcrumbs_list', breadcrumbsList)
