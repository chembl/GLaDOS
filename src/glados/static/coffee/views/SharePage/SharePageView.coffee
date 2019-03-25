glados.useNameSpace 'glados.views.SharePage',
  SharePageView: Backbone.View.extend

    events:
      'click .BCK-Shorten-link': 'shortenOrExpandURL'

    initialize: ->

      @model.on 'change:state', @processModelState, @

    render: ->
      console.log 'RENDER SHARE VIEW'
      @model.resetState()
      @processModelState()
      console.log 'model: ', @model
#      $element = $(@el)
#      needsShortening = glados.Utils.URLS.URLNeedsShortening(window.location.href, 100)

#      match = window.location.href.match(glados.Settings.SHORTENING_MATCH_REPEXG)
#      @renderURLContainer(window.location.href)
#
#      if needsShortening and match?
#
#        $shortenBtnContainer = $element.find('.BCK-shortenBtnContainer')
#        glados.Utils.fillContentForElement($shortenBtnContainer)
#        $shortenBTN = $shortenBtnContainer.find('.BCK-Shorten-link')
#        @shortenLinkBound = @shortenURL.bind(@)
#        $shortenBTN.click(@shortenLinkBound)

      @showModal()

    processModelState: ->

      console.log 'process model state'
      currentState = @model.get('state')

      if currentState == glados.models.SharePage.SharePageModel.States.INITIAL_STATE
        @renderURLContainer(@model.get('long_href'))
      else if currentState == glados.models.SharePage.SharePageModel.States.SHORTENING_URL
        @renderMessage('Processing...')

    renderURLContainer: (link) ->

      $element = $(@el)
      $inkToShareContainer = $element.find('.BCK-LinkToShare')

      config =
        value: link

      ButtonsHelper.initCroppedContainer($inkToShareContainer, config, cleanup=true)

    renderMessage: (msg) ->

      $msgContainer = $(@el).find('.Handlebars-Shortening-Info')
      $msgContainer.text(msg)

    shortenOrExpandURL: (event) ->

      $clickedBtn = $(event.currentTarget)
      console.log 'shortenOrExpandURL'
      isShortening = $clickedBtn.attr('data-shorten-or-expand') == 'shorten'
      console.log 'isShortening: ', isShortening
      if isShortening
        @model.shortenURL()

    showModal: ->

      $element = $(@el)
      $element.modal('open')

    shortenURL: ->



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