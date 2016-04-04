# View that renders the Molecule Features section
# from the compound report card
CompoundFeaturesView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @

  render: ->
    @renderMoleculeType()
    @renderFirstInClass()

    # until here, all the visible content has been rendered.
    $(@el).children('.card-preolader-to-hide').hide()
    $(@el).children(':not(.card-preolader-to-hide, .card-load-error)').show()

    @activateTooltips()

  renderMoleculeType: ->
    moltype_div = $(@el).find('#Bck-MolType')
    console.log(@model.get('molecule_type'))

    rendered = Handlebars.compile($('#Handlebars-Compound-MoleculeFeatures-MolType').html())
      active_class: @getMolFeatureDetails('molecule_type', 0)
      filename: @getMolFeatureDetails('molecule_type', 1)
      tooltip: @getMolFeatureDetails('molecule_type', 2)
      description: @getMolFeatureDetails('molecule_type', 3)

    moltype_div.html(rendered)

  renderFirstInClass: ->

    first_in_class_div = $(@el).find('#Bck-FirstInClass')
    console.log(@model.get('first_in_class'))

    first_in_class_div.html Handlebars.compile($('#Handlebars-Compound-MoleculeFeatures-FirstInClass').html())
      active_class: @getMolFeatureDetails('first_in_class', 0)
      filename: @getMolFeatureDetails('first_in_class', 1)
      tooltip: @getMolFeatureDetails('first_in_class', 2)
      description: @getMolFeatureDetails('first_in_class', 3)

  getMolFeatureDetails: (feature, position) ->
    return @molFeatures[feature][@model.get(feature)][position]

  # active class, tooltip, mobile description
  molFeatures:
    'molecule_type':
      'Small molecule': ['active', 'mt_small_molecule', 'Molecule Type: small molecule', 'Small Molecule']
      'Antibody': ['active', 'mt_antibody', 'Molecule Type: Antibody', 'Antibody']
      'Enzyme': ['active', 'mt_enzyme', 'Molecule Type: Enzyme', 'Enzyme']
    'first_in_class':
      '0': ['', 'first_in_class', 'First in Class: No', 'First in Class']
      '1': ['active', 'first_in_class', 'First in Class: Yes', 'First in Class']
