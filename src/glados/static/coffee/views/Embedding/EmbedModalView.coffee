glados.useNameSpace 'glados.views.Embedding',
  EmbedModalView: Backbone.View.extend

    initialize: ->

      $parentElement = $(@el)

      if EMBEDED?
        # prevent unnecessary loops
        $parentElement.find('.embed-modal-trigger').remove()
        $parentElement.find('.embed-modal').remove()
        return

      $modalTrigger = $parentElement.find('.embed-modal-trigger')
      modalNumber = Math.floor((Math.random() * 1000000) + 1)
      @modalId = 'embed-modal-for-' + modalNumber

      modalContent = glados.Utils.getContentFromTemplate('Handlebars-Common-EmbedModal', {modal_id: @modalId })
      $generatedModalsContainer = $('#BCK-GeneratedModalsContainer')
      $generatedModalsContainer.append(modalContent)
      $generatedModalsContainer.find("##{@modalId}").modal()

      $modalTrigger.attr('href', "##{@modalId}" )
      $modalTrigger.attr('rendered', 'false')

      embedURL = @model.get('embed_url')
      $modalTrigger.attr('data-embed-url', embedURL)
      $modalTrigger.click @renderModalPreview

    renderModalPreview: ->

      $clicked = $(@)
      if $clicked.attr('rendered') == 'true'
        return

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
      $clicked.attr('rendered', 'true')
