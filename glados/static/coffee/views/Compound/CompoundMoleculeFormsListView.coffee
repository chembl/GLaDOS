# View that renders the each of the Molecule forms of the Alternate Forms section
# of the compound report card
# load CardView first!
# also make sure the html can access the handlebars templates!
CompoundMoleculeFormsListView = CardView.extend

  initialize: ->
    @collection.on 'reset', @render, @
    @collection.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Compound'

  render: ->

    @addAllAlternateForms()

    # until here, all the visible content has been rendered.
    @showVisibleContent()

    @initEmbedModal('alternate_forms')
    @activateTooltips()
    @activateModals()

  addOneAlternateForm: (alternateForm) ->
    view = new CompoundMoleculeFormView({model: alternateForm});
    row = $(@el).find('#Bck-AlternateForms')
    row.append(view.render().el)


  addAllAlternateForms: ->
    @collection.forEach @addOneAlternateForm, @