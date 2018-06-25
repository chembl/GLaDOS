glados.useNameSpace 'glados.apps',
  BreadcrumbApp: class BreadcrumbApp

    @setBreadCrumb = (breadcrumbsList=[], longFilter, hideShareButton=false, askBeforeShortening=false, longFilterURL)->

      # make sure that the view exists
      glados.views.Breadcrumb.BreadcrumbsView.getInstance()

      breadcrumbs = glados.models.Breadcrumb.BreadcrumbModel.getInstance()
      breadcrumbs.set
        breadcrumbs_list: breadcrumbsList
        long_filter: longFilter
        long_filter_url: longFilterURL
        hide_share_button: hideShareButton
        hide_before_sortening: askBeforeShortening
