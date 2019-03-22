glados.useNameSpace 'glados.views.SharePage',
  SharePageView: Backbone.View.extend

    render: ->
      console.log 'RENDER SHARE VIEW'

      $element = $(@el)
      needsShortening = glados.Utils.URLS.URLNeedsShortening(window.location.href, 100)
      match = window.location.href.match(glados.Settings.SHORTENING_MATCH_REPEXG)
      @renderURLContainer(window.location.href)

      if needsShortening and match?

        $shortenBtnContainer = $element.find('.BCK-shortenBtnContainer')
        glados.Utils.fillContentForElement($shortenBtnContainer)
        $shortenBTN = $shortenBtnContainer.find('.BCK-Shorten-link')
        @shortenLinkBound = @shortenURL.bind(@)
        $shortenBTN.click(@shortenLinkBound)

      @showModal()

    renderURLContainer: (link) ->

      $element = $(@el)
      $inkToShareContainer = $element.find('.BCK-LinkToShare')

      config =
        value: link

      ButtonsHelper.initCroppedContainer($inkToShareContainer, config, cleanup=true)

    showModal: ->

      $element = $(@el)
      $element.modal('open')

    shortenURL: ->

      $shorteningInfo = $(@el).find('.BCK-shortening-info')

      urlToShorten = window.location.href.match(glados.Settings.SHORTENING_MATCH_REPEXG)[0]
      paramsDict =
        long_url: urlToShorten
      shortenURL = glados.doCSRFPost(glados.Settings.SHORTEN_URLS_ENDPOINT, paramsDict)

      thisView = @
      shortenURL.then (data) ->
        newHref = glados.Settings.SHORTENED_URL_GENERATOR
          hash: data.hash
          absolute: true
        glados.Utils.fillContentForElement($shorteningInfo, {}, customTemplate=undefined, fillWithPreloader=true)
        $shorteningInfo.empty()
        thisView.renderURLContainer(newHref)

#        thisView.setButtonStatusAsExpanding()

    setButtonStatusAsExpanding: ->

      $shortenBtnContainer = $(@el).find('.BCK-shortenBtnContainer')
      $shortenBTN = $shortenBtnContainer.find('.BCK-Shorten-link')

      $shortenBTN.removeClass('disabled')
      $shortenBTN.text('Expand Link')
      $shortenBTN.off('click', @shortenLinkBound)

      @expandLinkBound = @expandURL.bind(@)
      $shortenBTN.click(@expandLinkBound)