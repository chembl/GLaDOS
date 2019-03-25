glados.useNameSpace 'glados.views.SharePage',
  SharePageView: Backbone.View.extend

    events:
      'click .BCK-Shorten-link': 'shortenOrExpandURL'

    initialize: ->

      @model.on 'change:state', @processModelState, @

    render: ->

      @model.resetState()
      @processModelState()
      @showModal()

    processModelState: ->

      currentState = @model.get('state')

      if currentState == glados.models.SharePage.SharePageModel.States.INITIAL_STATE
        @renderURLContainer(@model.get('long_href'))
        @enableShortenButton()
        @setButtonStatusAsShortening()
        @renderMessage('')
      else if currentState == glados.models.SharePage.SharePageModel.States.SHORTENING_URL
        @renderMessage('Processing...')
        @disableShortenButton()
      else if currentState == glados.models.SharePage.SharePageModel.States.URL_SHORTENED
        @renderURLContainer(@model.get('short_href'))
        @renderMessage("The shortened url will expire on #{@model.get('expires')}")
        @enableShortenButton()
        @setButtonStatusAsExpanding()
      else if currentState == glados.models.SharePage.SharePageModel.States.EXPANDING_URL
        @disableShortenButton()
        @renderMessage('Expanding...')
      else if currentState == glados.models.SharePage.SharePageModel.States.URL_EXPANDED
        @renderURLContainer(@model.get('long_href'))
        @enableShortenButton()
        @setButtonStatusAsShortening()
        @renderMessage('')

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
      isShortening = $clickedBtn.attr('data-shorten-or-expand') == 'shorten'
      
      if isShortening
        @model.shortenURL()
      else
        @model.expandURL()

    showModal: ->

      $element = $(@el)
      $element.modal('open')

    disableShortenButton: ->

      $shortenBTN = $(@el).find('.BCK-Shorten-link')
      $shortenBTN.addClass('disabled')

    enableShortenButton: ->

      $shortenBTN = $(@el).find('.BCK-Shorten-link')
      $shortenBTN.removeClass('disabled')

    setButtonStatusAsExpanding: ->

      $shortenBTN = $(@el).find('.BCK-Shorten-link')
      $shortenBTN.text('Expand Link')
      $shortenBTN.attr('data-shorten-or-expand', 'expand')

    setButtonStatusAsShortening: ->

      $shortenBTN = $(@el).find('.BCK-Shorten-link')
      $shortenBTN.text('Shorten Link')
      $shortenBTN.attr('data-shorten-or-expand', 'shorten')

