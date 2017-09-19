# View that renders the each of the Molecule forms of the Alternate Forms section
# of the compound report card
# load CardView first!
# also make sure the html can access the handlebars templates!
CompoundMoleculeFormsListView = CardView.extend

  initialize: ->
    @collection.on 'reset', @.render, @
    @collection.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Compound'
    @paginatedView = glados.views.PaginatedViews.PaginatedViewFactory.getNewCardsPaginatedView(@collection, @el)

    @initEmbedModal('alternate_forms')
    @activateModals()
    @render()

  render: ->
    if @collection.length == 1 and @collection.at(0).get('molecule_chembl_id') == GlobalVariables.CHEMBL_ID and not GlobalVariables['EMBEDED']
      $('#AlternateFormsOfCompoundInChEMBL').hide()

    glados.Utils.fillContentForElement $(@el).find('.alternate-compounds-title'),
      chembl_id: GlobalVariables.CHEMBL_ID

    @showCardContent()
