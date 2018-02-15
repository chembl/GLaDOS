glados.useNameSpace 'glados.helpers',

  # --------------------------------------------------------------------------------------------------------------------
  # This class provides support to functionalities related with generating and handling embed modals.
  # --------------------------------------------------------------------------------------------------------------------
  EmbedModalsHelper: class EmbedModalsHelper

    @initEmbedModal = ->

    # this function is to be used for the click event in the embed modal button.
    # it can get all the information needed from the clicked element, no closure is needed.
    @renderModalPreview = ->

      $clicked = $(@)
      if $clicked.attr('rendered') == 'true'
        return

      sectionName = $clicked.attr('data-embed-sect-name')
      $modal = $($clicked.attr('href'))

      $codeElem = $modal.find('code')
      $chemblID = $clicked.attr('data-chembl-id')

      rendered = Handlebars.compile($('#Handlebars-Common-EmbedCode').html())
        base_url: glados.Settings.GLADOS_BASE_URL_FULL
        chembl_id: $chemblID
        section_name: sectionName
        resource_type: $clicked.attr('data-resource-type')

      $codeElem.text(rendered)
      $previewElem = $modal.find('.BCK-embed-preview')

      $codeElem = $modal.find('code')
      $codeToPreview = $codeElem.text()

      $previewElem.html($codeToPreview)


      $clicked.attr('rendered', 'true')