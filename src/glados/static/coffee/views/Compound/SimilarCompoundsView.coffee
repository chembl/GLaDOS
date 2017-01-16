# View that renders the similar compounds section
# from the compound report card
SimilarCompoundsView = CardView.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @resource_type = 'Target'

  render: ->

    $(@el).find('.similar-compounds-title').html Handlebars.compile( $('#Handlebars-CompRepCard-SimmilarCompounds-Title').html() )
      chembl_id: GlobalVariables.CHEMBL_ID

    if @collection.size() == 0 and !@collection.getMeta('force_show')
      $('#TargetRelations').hide()
      return

    @clearContentContainer()

    @fillTemplates()
    @fillPaginators()

    @showCardContent()
    @showPaginatedViewContent()
    @initEmbedModal('relations')
    @activateModals()

    @fillPageSelectors()
    @activateSelectors()