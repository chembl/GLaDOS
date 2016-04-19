# View that renders the Molecule Features section
# from the compound report card
CompoundFeaturesView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @

  render: ->
    @renderProperty('Bck-MolType', 'molecule_type')
    @renderProperty('Bck-RuleOfFive', 'ro5')
    @renderProperty('Bck-FirstInClass', 'first_in_class')
    @renderProperty('Bck-Chirality', 'chirality')
    @renderProperty('Bck-Prodrug', 'prodrug')
    @renderProperty('Bck-Oral', 'oral')
    @renderProperty('Bck-Parenteral', 'parenteral')
    @renderProperty('Bck-Topical', 'topical')
    @renderProperty('Bck-BlackBox', 'black_box_warning')
    @renderProperty('Bck-Availability', 'availability_type')

    # until here, all the visible content has been rendered.
    @showVisibleContent()

    @initEmbedModal('molecule_features')
    @activateModals()

    @activateTooltips()

  renderProperty: (div_id, property) ->

    property_div = $(@el).find('#' + div_id)

    property_div.html Handlebars.compile($('#Handlebars-Compound-MoleculeFeatures-IconContainer').html())
      active_class: @getMolFeatureDetails(property, 0)
      filename: @getMolFeatureDetails(property, 1)
      tooltip: @getMolFeatureDetails(property, 2)
      tooltip_position: @getMolFeatureDetails(property, 3)

  getMolFeatureDetails: (feature, position) ->
    return @molFeatures[feature][@model.get(feature)][position]

  # active class,filename, tooltip, mobile description, tooltip position
  molFeatures:
    'molecule_type':
      'Small molecule': ['active', 'mt_small_molecule', 'Molecule Type: small molecule','top']
      'Antibody': ['active', 'mt_antibody', 'Molecule Type: Antibody', 'top']
      'Enzyme': ['active', 'mt_enzyme', 'Molecule Type: Enzyme', 'top']
    'first_in_class':
      '-1': ['', 'first_in_class', 'First in Class: Undefined', 'top']
      '0': ['', 'first_in_class', 'First in Class: No', 'top']
      '1': ['active', 'first_in_class', 'First in Class: Yes', 'top']
    'chirality':
      '-1': ['', 'chirality_0', 'Chirality: Undefined', 'top']
      '0': ['active', 'chirality_0', 'Chirality: Racemic Mixture', 'top']
      '1': ['active', 'chirality_1', 'Chirality: Single Stereoisomer', 'top']
      '2': ['', 'chirality_1', 'Chirality: Achiral Molecule', 'top']
    'prodrug':
      '-1': ['', 'prodrug', 'Prodrug: Undefined', 'top'],
      '0': ['', 'prodrug', 'Prodrug: No', 'top']
      '1': ['active', 'prodrug', 'Prodrug: Yes',  'top']
    'oral':
      'true': ['active', 'oral', 'Oral: Yes', 'bottom']
      'false': ['', 'oral', 'Oral: No', 'bottom']
    'parenteral':
      'true': ['active', 'parenteral', 'Parenteral: Yes', 'bottom']
      'false': ['', 'parenteral', 'Parenteral: No', 'bottom']
    'topical':
      'true': ['active', 'topical', 'Topical: Yes', 'bottom']
      'false': ['', 'topical', 'Topical: No', 'bottom']
    'black_box_warning':
      '0': ['', 'black_box', 'Black Box: No', 'bottom']
      '1': ['active', 'black_box', 'Black Box: Yes', 'bottom']
    'availability_type':
      '-1': ['', 'availability_0', 'Availability: Undefined', 'bottom']
      '0': ['active', 'availability_0', 'Availability: Discontinued', 'bottom']
      '1': ['active', 'availability_1', 'Availability: Prescription Only', 'bottom']
      '2': ['active', 'availability_2', 'Availability: Over the Counter', 'bottom']
    'ro5':
      'true': ['active', 'rule_of_five', 'Rule Of Five: Yes', 'top']
      'false': ['', 'rule_of_five', 'Rule Of Five: No', 'top']
