glados.useNameSpace 'glados.models.base.Breadcrumb',
  Breadcrumb: Backbone.Model.extend
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
          urlString = url.replace /_/g, ' '
          urlString = urlString.replace urlString.charAt(0), urlString.charAt(0).toUpperCase()
          breadcrumbs[url] =
            label: urlString
            url: current_url + '/' + url
          current_url = current_url + '/' + url

      return breadcrumbs



