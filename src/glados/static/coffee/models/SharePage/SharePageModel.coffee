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
      })

    shortenURL: ->

      @set('state', glados.models.SharePage.SharePageModel.States.SHORTENING_URL)

      urlToShorten = window.location.href.match(glados.Settings.SHORTENING_MATCH_REPEXG)[0]
      paramsDict =
        long_url: urlToShorten
      shortenURL = glados.doCSRFPost(glados.Settings.SHORTEN_URLS_ENDPOINT, paramsDict)



glados.models.SharePage.SharePageModel.States =
  INITIAL_STATE: 'INITIAL_STATE'
  SHORTENING_URL: 'SHORTENING_URL'