glados.useNameSpace 'glados.models.base.Breadcrumb',
  Breadcrumb: Backbone.Model.extend
    initialize: ->
      @complete_url = document.URL;

glados.models.base.Breadcrumb.FULL_URL = document.URL
glados.models.base.Breadcrumb.BASE_URL =
  name: 'ChEMBL Database'
  url: glados.Settings.GLADOS_BASE_URL_FULL
glados.models.base.Breadcrumb.BREADCRUMBS = []


