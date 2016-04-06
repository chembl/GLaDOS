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

    #@initEmbedModal('mechanism_of_action')
    #@renderModalPreview()
    #@activateTooltips()

  addOneAlternateForm: (alternateForm) ->
    console.log('oneAlternate form')
    console.log(alternateForm)
    view = new CompoundMoleculeFormView({model: alternateForm});
    row = $(@el).find('.card-content .row')
    row.append(view.render().el)


  addAllAlternateForms: ->
    @collection.forEach @addOneAlternateForm, @