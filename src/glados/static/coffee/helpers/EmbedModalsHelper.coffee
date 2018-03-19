glados.useNameSpace 'glados.helpers',

  # --------------------------------------------------------------------------------------------------------------------
  # This class provides support to functionalities related with generating and handling embed modals.
  # --------------------------------------------------------------------------------------------------------------------
  EmbedModalsHelper: class EmbedModalsHelper

    # $parentElement is the parent element that contains the embed modal and trigger button
    @initEmbedModal = ($parentElement, embedURL)->

      embedModel = new glados.models.Embedding.EmbedModalModel
        embed_url: embedURL

      embedView = new glados.views.Embedding.EmbedModalView
        model: embedModel
        el: $parentElement