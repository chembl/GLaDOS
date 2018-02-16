glados.useNameSpace 'glados.helpers',

  # --------------------------------------------------------------------------------------------------------------------
  # This class provides support to functionalities related with generating and handling embed modals.
  # --------------------------------------------------------------------------------------------------------------------
  EmbedModalsHelper: class EmbedModalsHelper

    # $parentElement is the parent element that contains the embed modal and trigger button
    @initEmbedModal = ($parentElement, embedURL)->
      
      if EMBEDED?
        # prevent unnecessary loops
        $parentElement.find('.embed-modal-trigger').remove()
        $parentElement.find('.embed-modal').remove()
        return

      $modalTrigger = $parentElement.find('.embed-modal-trigger')
      $modal = $parentElement.find('.embed-modal')

      modalNumber = Math.floor((Math.random() * 1000000) + 1)

      modalId = 'embed-modal-for-' + modalNumber
      $modal.attr('id', modalId)
      $modalTrigger.attr('href', "##{modalId}" )
      $modalTrigger.attr('rendered', 'false')

      $modalTrigger.attr('data-embed-url', embedURL)
      $modalTrigger.click @renderModalPreview

    # this function is to be used for the click event in the embed modal button.
    # it can get all the information needed from the clicked element, no closure is needed.
    @renderModalPreview = ->

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