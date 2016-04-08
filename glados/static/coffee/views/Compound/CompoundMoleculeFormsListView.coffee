# View that renders the each of the Molecule forms of the Alternate Forms section
# of the compound report card
# load CardView first!
# also make sure the html can access the handlebars templates!
CompoundMoleculeFormsListView = CardView.extend

  initialize: ->
    @collection.on 'reset', @render, @
    @collection.on 'error', @.showCompoundErrorCard, @

  render: ->

    @addAllAlternateForms()

    # until here, all the visible content has been rendered.
    $(@el).children('.card-preolader-to-hide').hide()
    $(@el).children(':not(.card-preolader-to-hide, .card-load-error)').show()

    @initEmbedModal('alternate_forms')
    @renderModalPreview()
    @activateTooltips()
    @activateModals()

  addOneAlternateForm: (alternateForm) ->
    view = new CompoundMoleculeFormView({model: alternateForm});
    row = $(@el).find('#Bck-AlternateForms')
    row.append(view.render().el)


  addAllAlternateForms: ->
    @collection.forEach @addOneAlternateForm, @