# View that renders the Molecule Features section
# from the compound report card
CompoundFeaturesView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @

  render: ->
    @renderMoleculeType()
    @activateTooltips()

    # until here, all the visible content has been rendered.
    $(@el).children('.card-preolader-to-hide').hide()
    $(@el).children(':not(.card-preolader-to-hide, .card-load-error)').show()

    @activateTooltips()

  renderMoleculeType: ->
    moltype_div = $(@el).find('#Bck-MolType')

    rendered = Handlebars.compile($('#Handlebars-Compound-MoleculeFeatures-MolType').html())
      active_class: 'active'
      filename: @molTypeToFilename[@model.get('molecule_type')]
      tooltip: @molTypeToTooltip[@model.get('molecule_type')]
      description: @molTypeToDesc[@model.get('molecule_type')]

    moltype_div.html(rendered)


  molTypeToFilename:
    'Small molecule': 'mt_small_molecule'

  molTypeToTooltip:
    'Small molecule': 'Molecule Type: small molecule'

  molTypeToDesc:
    'Small molecule': 'Small Molecule'