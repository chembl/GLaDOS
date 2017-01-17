# View that renders the each of the Molecule forms of the Alternate Forms section
# of the compound report card
# load CardView first!
# also make sure the html can access the handlebars templates!
CompoundMoleculeFormsListView = CardView.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @collection.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Compound'

  render: ->

    @clearContentContainer()

    @fillTemplates()
    @fillPaginators()

    @showCardContent()
    @showPaginatedViewContent()
    @initEmbedModal('alternate_forms')
    @activateModals()

    @fillPageSelectors()
    @activateSelectors()
