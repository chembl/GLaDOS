# View that renders the Molecule Features section
# from the compound report card
CompoundFeaturesView = CardView.extend

  initialize: ->

    @config = arguments[0].config
    CardView.prototype.initialize.call(@, arguments)
    @tableCellMode = arguments[0].table_cell_mode

    $gridContainer = $(@el).find('.BCK-FeaturesGrid')
    glados.Utils.fillContentForElement $gridContainer,
      table_cell_mode: @tableCellMode

    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Compound'

  render: ->

    metadata = @model.get('_metadata')
    showFirstRow = glados.Utils.getNestedValue(metadata, 'hierarchy.is_usan')
    showSecondRow = glados.Utils.getNestedValue(metadata, 'hierarchy.is_approved_drug')

    if not (showFirstRow or showSecondRow)
      @hideSection()
      return

    @showSection() unless @config.is_outside_an_entity_report_card

    if showFirstRow
      @renderProperty('Bck-MolType', 'molecule_type')
      @renderProperty('Bck-RuleOfFive', 'ro5')
      @renderProperty('Bck-FirstInClass', 'first_in_class')
      @renderProperty('Bck-Chirality', 'chirality')
      @renderProperty('Bck-Prodrug', 'prodrug')
    else
      @hideFirstRow()

    if showSecondRow
      @renderProperty('Bck-Oral', 'oral')
      @renderProperty('Bck-Parenteral', 'parenteral')
      @renderProperty('Bck-Topical', 'topical')
      @renderProperty('Bck-BlackBox', 'black_box_warning')
      @renderProperty('Bck-Availability', 'availability_type')
    else
      @hideSecondRow()

    # until here, all the visible content has been rendered.
    @showCardContent()

    @initEmbedModal('molecule_features', @model.get('molecule_chembl_id'))
    @activateModals()

    @activateTooltips()

  hideFirstRow: -> $(@el).find('.BCK-first-row').hide()
  hideSecondRow: -> $(@el).find('.BCK-second-row').hide()

  renderProperty: (featureName, property) ->
    $propertyDiv = $(@el).find('[data-feature-name="' + featureName + '"]')

    glados.Utils.fillContentForElement $propertyDiv,
      active_class: @getMolFeatureDetails(property, 0)
      tooltip: @getMolFeatureDetails(property, 1)
      tooltip_position: @getMolFeatureDetails(property, 2)
      icon_class: @getMolFeatureDetails(property, 3)
      table_cell_mode: @tableCellMode

  getMolFeatureDetails: (feature, position) ->
    if feature == 'molecule_type' and @model.get('natural_product') == '1'
      @molFeatures[feature]['Natural product'][position]
    else if feature == 'molecule_type' and @model.get('polymer_flag') == true
      @molFeatures[feature]['Small molecule polymer'][position]
    else if feature == 'molecule_type' and parseInt(@model.get('inorganic_flag')) == 1
      @molFeatures[feature]['Inorganic'][position]
    else
      return @molFeatures[feature][@model.get(feature)][position]

  # active class,filename, tooltip, mobile description, tooltip position
  molFeatures:
    'molecule_type':
      'Small molecule': ['active', 'Drug Type: Synthetic Small Molecule','top', 'small-molecule']
      'Natural product': ['active', 'Drug Type: natural product','top', 'natural']
      'Small molecule polymer': ['active', 'Drug Type: small molecule polymer','top', 'polymer']
      'Antibody': ['active', 'Molecule Type: Antibody', 'top', 'antibody']
      'Enzyme': ['active', 'Molecule Type: Enzyme', 'top', 'enzyme']
      'Oligosaccharide': ['active', 'Molecule Type: Oligosaccharide', 'top', 'oligosaccharide']
      'Protein': ['active', 'Molecule Type: Oligopeptide', 'top', 'protein']
      'Oligonucleotide': ['active', 'Molecule Type: Oligonucleotide', 'top', 'oligonucleotide']
      'Cell': ['active', 'Drug Type: Cell Based', 'top', 'cell']
      'Unknown': ['active', 'Drug Type: Unknown', 'top', 'unknown']
      'Unclassified': ['active', 'Drug Type: Unclassified', 'top', 'unknown']
      'Inorganic': ['active', 'Drug Type: Inorganic','top', 'inorganic']
    'first_in_class':
      '-1': ['off', 'First in Class: Undefined', 'top', 'first_in_class']
      '0': ['off', 'First in Class: No', 'top', 'first_in_class']
      '1': ['active', 'First in Class: Yes', 'top', 'first_in_class']
    'chirality':
      '-1': ['off', 'Chirality: Undefined', 'top', 'racemic_mixture']
      '0': ['active', 'Chirality: Racemic Mixture', 'top', 'racemic_mixture']
      '1': ['active', 'Chirality: Single Stereoisomer', 'top', 'chirally_pure']
      '2': ['off', 'Chirality: Achiral Molecule', 'top', 'chirally_pure']
    'prodrug':
      '-1': ['off', 'Prodrug: Undefined', 'top', 'prodrug'],
      '0': ['off', 'Prodrug: No', 'top', 'prodrug']
      '1': ['off', 'Prodrug: Yes',  'top', 'prodrug']
    'oral':
      'true': ['off', 'Oral: Yes', 'bottom', 'oral']
      'false': ['off', 'Oral: No', 'bottom', 'oral']
    'parenteral':
      'true': ['off', 'Parenteral: Yes', 'bottom', 'parenteral']
      'false': ['off', 'Parenteral: No', 'bottom', 'parenteral']
    'topical':
      'true': ['active', 'Topical: Yes', 'bottom', 'topical']
      'false': ['off', 'Topical: No', 'bottom', 'topical']
    'black_box_warning':
      '0': ['off', 'Black Box: No', 'bottom', 'black_box']
      '1': ['active', 'Black Box: Yes', 'bottom', 'black_box']
    'availability_type':
      '-2': ['active', 'Availability: Withdrawn', 'bottom', 'withdrawn']
      '-1': ['off', 'Availability: Undefined', 'bottom', 'prescription']
      '0': ['active', 'Availability: Discontinued', 'bottom', 'discontinued']
      '1': ['active', 'Availability: Prescription Only', 'bottom', 'prescription']
      '2': ['active', 'Availability: Over the Counter', 'bottom', 'otc']
    'ro5':
      'true': ['active', 'Rule Of Five: Yes', 'top', 'rule_of_five']
      'false': ['off', 'Rule Of Five: No', 'top', 'rule_of_five']
