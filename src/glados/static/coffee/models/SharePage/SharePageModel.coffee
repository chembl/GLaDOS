glados.useNameSpace 'glados.models.SharePage',

  # This model handles the communication with the server for structure searches
  SharePageModel: Backbone.Model.extend

    initialize: ->

      @set('state', glados.models.SharePage.SharePageModel.States.INITIAL_STATE)

    resetState: ->

      @set({
        'state': glados.models.SharePage.SharePageModel.States.INITIAL_STATE
        'long_href': window.location.href
        'short_href': undefined
        'expires': undefined
        'url_hash': undefined
      })

    shortenURL: ->

      @set('state', glados.models.SharePage.SharePageModel.States.SHORTENING_URL)

      urlToShorten = window.location.href.match(glados.Settings.SHORTENING_MATCH_REPEXG)[0]
      paramsDict =
        long_url: urlToShorten
      shortenURL = glados.doCSRFPost(glados.Settings.SHORTEN_URLS_ENDPOINT, paramsDict)

      thisModel = @
      shortenURL.then (data) ->
        shortHref = glados.Settings.SHORTENED_URL_GENERATOR
          hash: data.hash
          absolute: true

        thisModel.set
          'short_href': shortHref
          'expires': data.expires
          'url_hash': data.hash

        thisModel.set('state', glados.models.SharePage.SharePageModel.States.URL_SHORTENED)

    expandURL: ->

      console.log 'expand url!'
      @set('state', glados.models.SharePage.SharePageModel.States.EXPANDING_URL)
      console.log @get('url_hash')
      getExpandedURL = $.getJSON(glados.Settings.EXTEND_URLS_ENDPOINT_URL + @get('url_hash'))

      thisModel = @
      getExpandedURL.then (data) ->

        console.log 'url expanded ', data
        longHref = glados.Settings.GLADOS_BASE_URL_FULL + data.long_url
        console.log longHref
        thisModel.set
          'state': glados.models.SharePage.SharePageModel.States.URL_EXPANDED
          'long_href': longHref

glados.models.SharePage.SharePageModel.States =
  INITIAL_STATE: 'INITIAL_STATE'
  SHORTENING_URL: 'SHORTENING_URL'
  URL_SHORTENED: 'URL_SHORTENED'
  EXPANDING_URL: 'EXPANDING_URL'
  URL_EXPANDED: 'URL_EXPANDED'