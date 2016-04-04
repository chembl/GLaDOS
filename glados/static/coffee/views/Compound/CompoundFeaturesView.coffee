# View that renders the Molecule Features section
# from the compound report card
CompoundFeaturesView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @

  render: ->
    @renderProperty('Bck-MolType', 'molecule_type')
    @renderProperty('Bck-FirstInClass', 'first_in_class')
    @renderProperty('Bck-Chirality', 'chirality')
    @renderProperty('Bck-Prodrug', 'prodrug')
    @renderProperty('Bck-Oral', 'oral')
    @renderProperty('Bck-Parenteral', 'parenteral')
    @renderProperty('Bck-Topical', 'topical')
    @renderProperty('Bck-BlackBox', 'black_box_warning')
    @renderProperty('Bck-Availability', 'availability_type')

    # until here, all the visible content has been rendered.
    $(@el).children('.card-preolader-to-hide').hide()
    $(@el).children(':not(.card-preolader-to-hide, .card-load-error)').show()

    @activateTooltips()

  renderProperty: (div_id, property) ->

    property_div = $(@el).find('#' + div_id)
    console.log(property + ':')
    console.log(@model.get(property))

    property_div.html Handlebars.compile($('#Handlebars-Compound-MoleculeFeatures-IconContainer').html())
      active_class: @getMolFeatureDetails(property, 0)
      filename: @getMolFeatureDetails(property, 1)
      tooltip: @getMolFeatureDetails(property, 2)
      description: @getMolFeatureDetails(property, 3)
      tooltip_position: @getMolFeatureDetails(property, 4)

  getMolFeatureDetails: (feature, position) ->
    return @molFeatures[feature][@model.get(feature)][position]

  # active class,filename, tooltip, mobile description, tooltip position
  molFeatures:
    'molecule_type':
      'Small molecule': ['active', 'mt_small_molecule', 'Molecule Type: small molecule', 'Small Molecule', 'top']
      'Antibody': ['active', 'mt_antibody', 'Molecule Type: Antibody', 'Antibody', 'top']
      'Enzyme': ['active', 'mt_enzyme', 'Molecule Type: Enzyme', 'Enzyme', 'top']
    'first_in_class':
      '0': ['', 'first_in_class', 'First in Class: No', 'First in Class', 'top']
      '1': ['active', 'first_in_class', 'First in Class: Yes', 'First in Class', 'top']
    'chirality':
      '0': ['active', 'chirality_0', 'Chirality: Racemic Mixture', 'Racemic Mixture', 'top']
      '1': ['active', 'chirality_1', 'Chirality: Single Stereoisomner', 'Single Stereoisomner', 'top']
      '2': ['', 'chirality_1', 'Chirality: Achiral Molecule', 'Achiral Molecule', 'top']
    'prodrug':
      '0': ['', 'prodrug', 'Prodrug: No', 'Prodrug', 'top']
      '1': ['active', 'prodrug', 'Prodrug: Yes', 'Prodrug', 'top']
    'oral':
      'true': ['active', 'oral', 'Oral: Yes', 'Oral', 'bottom']
      'false': ['', 'oral', 'Oral: No', 'Oral', 'bottom']
    'parenteral':
      'true': ['active', 'parenteral', 'Parenteral: Yes', 'Parenteral', 'bottom']
      'false': ['', 'parenteral', 'Parenteral: No', 'Parenteral', 'bottom']
    'topical':
      'true': ['active', 'topical', 'Topical: Yes', 'Topical', 'bottom']
      'false': ['', 'topical', 'Topical: No', 'Topical', 'bottom']
    'black_box_warning':
      '0': ['', 'black_box', 'Black Box: No', 'Black Box', 'bottom']
      '1': ['active', 'black_box', 'Black Box: Yes', 'Black Box', 'bottom']
    'availability_type':
      '0': ['active', 'availability_0', 'Availability: Discontinued', 'Discontinued', 'bottom']
      '1': ['active', 'availability_1', 'Availability: Prescription Only', 'Prescription Only', 'bottom']
      '2': ['active', 'availability_2', 'Availability: Over the Counter', 'Over the Counter', 'bottom']
