glados.useNameSpace 'glados.helpers',

  # --------------------------------------------------------------------------------------------------------------------
  # This class provides support to functionalities related with generating and handling embed modals.
  # --------------------------------------------------------------------------------------------------------------------
  EmbedModalsHelper: class EmbedModalsHelper

    # $parentElement is the parent element that contains the embed modal and trigger button
    @initEmbedModal = ($parentElement, embedURL) ->

      embedModel = new glados.models.Embedding.EmbedModalModel
        embed_url: embedURL

      new glados.views.Embedding.EmbedModalView
        model: embedModel
        el: $parentElement

      return embedModel

    @initEmbedModalForCollectionView: (embedURLGenerator, parentView) ->

      if GlobalVariables['EMBEDED']
        return

      currentStateString = JSON.stringify(parentView.collection.getStateJSON())
      base64StateString = btoa(currentStateString)

      embedURLRelative = embedURLGenerator
        state: encodeURIComponent(base64StateString)
      embedURL = "#{glados.Settings.GLADOS_BASE_URL_FULL}embed/#{embedURLRelative}"

      if not parentView.embedModel?
        parentView.embedModel = glados.helpers.EmbedModalsHelper.initEmbedModal($(parentView.el), embedURL)
      else
        parentView.embedModel.set
          embed_url: embedURL

      # shorten the url, but in any case the original one is already shown
      getShortenedURL = glados.Utils.URLS.getShortenedEmbebURLPromise(embedURL)
      thisView = parentView
      getShortenedURL.then (data) ->
        newEmbedURL = glados.Settings.SHORTENED_EMBED_URL_GENERATOR
          hash: encodeURIComponent(data.hash)
        thisView.embedModel.set
          embed_url: newEmbedURL