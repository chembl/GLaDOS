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
    if @collection.length == 1 and @collection.at(0).get('molecule_chembl_id') == GlobalVariables.CHEMBL_ID and not GlobalVariables['EMBEDED']
      $('#AlternateFormsOfCompoundInChEMBL').hide()

    $(@el).find('.alternate-compounds-title').html Handlebars.compile($('#Handlebars-CompRepCard-AlternateCompounds-Title').html())
      chembl_id: GlobalVariables.CHEMBL_ID

    @clearContentContainer()

    @fillTemplates()
    @fillPaginators()

    @showCardContent()
    @showPaginatedViewContent()
    @initEmbedModal('alternate_forms')
    @activateModals()

    @fillPageSelectors()
    @activateSelectors()
