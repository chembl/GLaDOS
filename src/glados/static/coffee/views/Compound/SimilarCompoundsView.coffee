# View that renders the similar compounds section
# from the compound report card
SimilarCompoundsView = CardView.extend

  initialize: ->

    CardView.prototype.initialize.call(@, arguments)
    @collection.on 'reset', @.render, @
    @collection.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Compound'

    @paginatedView = glados.views.PaginatedViews.PaginatedViewFactory.getNewCardsCarouselView(@collection, @el)

    @initEmbedModal('similar', arguments[0].molecule_chembl_id)
    @activateModals()
    @render()

  render: ->

    if @collection.size() == 0 and !@collection.getMeta('force_show')
      return

    @showSection()
    glados.Utils.fillContentForElement $(@el).find('.similar-compounds-title'),
      chembl_id: GlobalVariables.CHEMBL_ID
      similarity: glados.Settings.DEFAULT_SIMILARITY_THRESHOLD

    glados.Utils.fillContentForElement $(@el).find('.see-full-list-link'),
      chembl_id: GlobalVariables.CHEMBL_ID
      similarity_threshold: glados.Settings.DEFAULT_SIMILARITY_THRESHOLD

    @showCardContent()