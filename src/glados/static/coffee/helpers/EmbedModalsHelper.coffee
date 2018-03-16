glados.useNameSpace 'glados.helpers',

  # --------------------------------------------------------------------------------------------------------------------
  # This class provides support to functionalities related with generating and handling embed modals.
  # --------------------------------------------------------------------------------------------------------------------
  EmbedModalsHelper: class EmbedModalsHelper

    # $parentElement is the parent element that contains the embed modal and trigger button
    @initEmbedModal = ($parentElement, embedURL)->

      console.log 'INIT EMBED MODAL'
      if EMBEDED?
        # prevent unnecessary loops
        $parentElement.find('.embed-modal-trigger').remove()
        $parentElement.find('.embed-modal').remove()
        return

      $modalTrigger = $parentElement.find('.embed-modal-trigger')
      modalNumber = Math.floor((Math.random() * 1000000) + 1)
      modalId = 'embed-modal-for-' + modalNumber

      modalContent = glados.Utils.getContentFromTemplate('Handlebars-Common-EmbedModal', {modal_id: modalId })
      $generatedModalsContainer = $('#BCK-GeneratedModalsContainer')
      $generatedModalsContainer.append(modalContent)
      $generatedModalsContainer.find("##{modalId}").modal()

      $modalTrigger.attr('href', "##{modalId}" )
      $modalTrigger.attr('rendered', 'false')

      $modalTrigger.attr('data-embed-url', embedURL)
      $modalTrigger.click @renderModalPreview

    # this function is to be used for the click event in the embed modal button.
    # it can get all the information needed from the clicked element, no closure is needed.
    @renderModalPreview = ->

      console.log 'render modal preview!!!'
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