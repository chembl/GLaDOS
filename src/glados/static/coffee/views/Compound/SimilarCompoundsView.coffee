# View that renders the similar compounds section
# from the compound report card
SimilarCompoundsView = CardView.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @resource_type = 'Compound'

  render: ->

    $(@el).find('.similar-compounds-title').html Handlebars.compile( $('#Handlebars-CompRepCard-SimmilarCompounds-Title').html() )
      chembl_id: GlobalVariables.CHEMBL_ID
      similarity: glados.Settings.DEFAULT_SIMILARITY_THRESHOLD

    $(@el).find('.see-full-list-link').html Handlebars.compile( $('#Handlebars-CompRepCard-SimmilarCompounds-Link').html() )
      chembl_id: GlobalVariables.CHEMBL_ID
      similarity_threshold: glados.Settings.DEFAULT_SIMILARITY_THRESHOLD


    if @collection.size() == 0 and !@collection.getMeta('force_show')
      $('#TargetRelations').hide()
      return

    @clearContentContainer()

    @fillTemplates()
    @fillPaginators()

    @showCardContent()
    @showPaginatedViewContent()
    @initEmbedModal('similar')
    @activateModals()

    @fillPageSelectors()
    @activateSelectors()