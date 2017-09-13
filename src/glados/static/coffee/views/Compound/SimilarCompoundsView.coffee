# View that renders the similar compounds section
# from the compound report card
SimilarCompoundsView = CardView.extend

  initialize: ->
    @collection.on 'reset', @.render, @
    @collection.on 'error', @.showCompoundErrorCard, @
    @collection.on 'error', (-> $('#SimilarCompounds').hide()), @
    @resource_type = 'Compound'

    @paginatedView = glados.views.PaginatedViews.PaginatedView.getNewCardsPaginatedView(@collection, @el)

    @initEmbedModal('similar')
    @activateModals()
    @render()

  render: ->

    glados.Utils.fillContentForElement $(@el).find('.similar-compounds-title'),
      chembl_id: GlobalVariables.CHEMBL_ID
      similarity: glados.Settings.DEFAULT_SIMILARITY_THRESHOLD

    glados.Utils.fillContentForElement $(@el).find('.see-full-list-link'),
      chembl_id: GlobalVariables.CHEMBL_ID
      similarity_threshold: glados.Settings.DEFAULT_SIMILARITY_THRESHOLD

    if @collection.size() == 0 and !@collection.getMeta('force_show')
      $('#TargetRelations').hide()
      return

    @showCardContent()