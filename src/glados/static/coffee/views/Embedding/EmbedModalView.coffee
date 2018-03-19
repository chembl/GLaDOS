glados.useNameSpace 'glados.views.Embedding',
  EmbedModalView: Backbone.View.extend

    initialize: ->

      $parentElement = $(@el)

      if EMBEDED?
        # prevent unnecessary loops
        $parentElement.find('.embed-modal-trigger').remove()
        $parentElement.find('.embed-modal').remove()
        return

      $triggerButtonContainer = $parentElement.find('.BCK-Embed-ButtonContainer')
      if $triggerButtonContainer.length == 0
        $triggerButtonContainer = $parentElement

      triggerButtonContent = glados.Utils.getContentFromTemplate('Handlebars-Common-EmbedTrigger')
      $triggerButtonContainer.append(triggerButtonContent)

      @$modalTrigger = $parentElement.find('.embed-modal-trigger')
      modalNumber = Math.floor((Math.random() * 1000000) + 1)
      @modalId = 'embed-modal-for-' + modalNumber

      modalContent = glados.Utils.getContentFromTemplate('Handlebars-Common-EmbedModal', {modal_id: @modalId })
      $generatedModalsContainer = $('#BCK-GeneratedModalsContainer')
      $generatedModalsContainer.append(modalContent)
      $generatedModalsContainer.find("##{@modalId}").modal()

      @$modalTrigger.attr('href', "##{@modalId}" )
      @$modalTrigger.attr('rendered', 'false')

      @model.on 'change', @updateTriggerURL
      @updateTriggerURL() unless not @model.get('embed_url')?
      @$modalTrigger.click @renderModalPreview

    showModalTrigger: -> @$modalTrigger.show()

    updateTriggerURL: ->

      embedURL = @model.get('embed_url')
      @$modalTrigger.attr('data-embed-url', embedURL)
      @showModalTrigger()

    renderModalPreview: ->

      $clicked = $(@)
      $modal = $($clicked.attr('href'))
      $codeElem = $modal.find('code')
      url = $clicked.attr('data-embed-url')
      rendered = Handlebars.compile($('#Handlebars-Common-EmbedCode').html())
        url: url
      $codeElem.text(rendered)

      $previewElem = $modal.find('.BCK-embed-preview')
      $codeElem = $modal.find('code')
      $codeToPreview = $codeElem.text()

      $previewElem.html($codeToPreview)
