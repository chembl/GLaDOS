glados.useNameSpace 'glados.models.Breadcrumb',
  BreadcrumbModel: Backbone.Model.extend
    initialize: ->
      @complete_url = document.URL
      @base_url = glados.Settings.GLADOS_BASE_URL_FULL
      @breadcrumbs_list = @getBreadcrumbsList(@base_url, @complete_url)

    getBreadcrumbsList: (baseURL, completeURL) ->
      breadcrumbsURL = completeURL.replace baseURL, ''
      breadcrumbsURL = breadcrumbsURL.split '/'

      current_url = @base_url.slice(0, -1)
      breadcrumbs = {}
      for url in breadcrumbsURL
        if url != ''
          urlString = @beautifyURL(url)
          breadcrumbs[url] =
            label: urlString
            url: current_url + '/' + url
          current_url = current_url + '/' + url

      return breadcrumbs

    beautifyURL: (url) ->
      newUrl = url.replace /_/g, ' '  #replace _ with spaces
      newUrl = newUrl.replace '#', ''
      newUrl = newUrl.replace /%20/g, ' '
      newUrl = newUrl.replace /%3A/g, ': '
      newUrl = newUrl.replace /%22/g, ''
      newUrl = newUrl.replace /AND/g, 'And'
      newUrl = newUrl.replace /OR/g, 'Or'
      newUrl = newUrl.replace newUrl.charAt(0), newUrl.charAt(0).toUpperCase()
      newUrl = newUrl.replace /\b(\w)/g, (x) -> x[0].toUpperCase()

      if newUrl.length > 30
        newUrl = newUrl.substring(0,50)+'...'

      return newUrl

# ----------------------------------------------------------------------------------------------------------------------
# Singleton
# ----------------------------------------------------------------------------------------------------------------------
glados.models.Breadcrumb.BreadcrumbModel.getInstance = ->
  if not glados.models.Breadcrumb.BreadcrumbModel.__model_instance?
    glados.models.Breadcrumb.BreadcrumbModel.__model_instance = new glados.models.Breadcrumb.BreadcrumbModel
  return glados.models.Breadcrumb.BreadcrumbModel.__model_instance