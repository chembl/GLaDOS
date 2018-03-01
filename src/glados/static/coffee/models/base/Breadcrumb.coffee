glados.useNameSpace 'glados.models.base.Breadcrumb',
  Breadcrumb: Backbone.Model.extend
    initialize: ->
      @complete_url = document.URL
      @base_url = glados.models.base.Breadcrumb.BASE_URL
      @breadcrumbs_list = @getBreadcrumbsList(@complete_url)


    getBreadcrumbsList: (baseURL) ->
     breadcrumbsUrl =

      return baseURL



glados.models.base.Breadcrumb.BASE_URL =
  name: 'ChEMBL Database'
  url: glados.Settings.GLADOS_BASE_URL_FULL



