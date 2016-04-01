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
    console.log(@model.get('molecule_type'))

    rendered = Handlebars.compile($('#Handlebars-Compound-MoleculeFeatures-MolType').html())
      active_class: 'active'
      filename: @molTypeToFilenameTooltipDesc[@model.get('molecule_type')][0]
      tooltip: @molTypeToFilenameTooltipDesc[@model.get('molecule_type')][1]
      description: @molTypeToFilenameTooltipDesc[@model.get('molecule_type')][2]

    moltype_div.html(rendered)


  # filename, tooltip, mobile description
  molTypeToFilenameTooltipDesc:
    'Small molecule': ['mt_small_molecule', 'Molecule Type: small molecule', 'Small Molecule']
    'Antibody': ['mt_antibody', 'Molecule Type: Antibody', 'Antibody']
    'Enzyme': ['mt_enzyme', 'Molecule Type: Enzyme', 'Enzyme']
