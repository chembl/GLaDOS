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
      data_icon: @getMolFeatureDetails(property, 1)
      tooltip: @getMolFeatureDetails(property, 2)
      tooltip_position: @getMolFeatureDetails(property, 3)
      icon_class: @getMolFeatureDetails(property, 4)
      table_cell_mode: @tableCellMode

  getMolFeatureDetails: (feature, position) ->
    if feature == 'molecule_type' and @model.get('natural_product') == '1'
      @molFeatures[feature]['Natural product'][position]
    else if feature == 'molecule_type' and @model.get('polymer_flag') == true
      @molFeatures[feature]['Small molecule polymer'][position]

    else
      return @molFeatures[feature][@model.get(feature)][position]

  # active class,filename, tooltip, mobile description, tooltip position
  molFeatures:
    'molecule_type':
      'Small molecule': ['active', 'l', 'Drug Type: Synthetic Small Molecule','top', 'icon-chembl']
      'Natural product': ['active', 'R', 'Drug Type: natural product','top', 'icon-generic']
      'Small molecule polymer': ['active', 'p', 'Drug Type: small molecule polymer','top', 'icon-chembl-2']
      'Antibody': ['active', 'a', 'Molecule Type: Antibody', 'top', 'icon-chembl']
      'Enzyme': ['active', 'e', 'Molecule Type: Enzyme', 'top', 'icon-chembl']
      'Oligosaccharide': ['active', 'A', 'Molecule Type: Oligosaccharide', 'top', 'icon-species']
      'Protein': ['active', 'A', 'Molecule Type: Oligopeptide', 'top', 'icon-species']
      'Oligonucleotide': ['active', 'A', 'Molecule Type: Oligonucleotide', 'top', 'icon-species']
      'Cell': ['active', 'A', 'Drug Type: Cell Based', 'top', 'icon-species']
      'Unknown': ['active', '?', 'Drug Type: Unknown', 'top', 'icon-generic']
      'Unclassified': ['active', '?', 'Drug Type: Unclassified', 'top', 'icon-generic']
    'first_in_class':
      '-1': ['', 'r', 'First in Class: Undefined', 'top', 'icon-chembl']
      '0': ['', 'r', 'First in Class: No', 'top', 'icon-chembl']
      '1': ['active', 'r', 'First in Class: Yes', 'top', 'icon-chembl']
    'chirality':
      '-1': ['', '3', 'Chirality: Undefined', 'top', 'icon-chembl']
      '0': ['active', '3', 'Chirality: Racemic Mixture', 'top', 'icon-chembl']
      '1': ['active', 'o', 'Chirality: Single Stereoisomer', 'top', 'icon-chembl']
      '2': ['', 'o', 'Chirality: Achiral Molecule', 'top', 'icon-chembl']
    'prodrug':
      '-1': ['', 'c', 'Prodrug: Undefined', 'top', 'icon-chembl'],
      '0': ['', 'c', 'Prodrug: No', 'top', 'icon-chembl']
      '1': ['active', 'c', 'Prodrug: Yes',  'top', 'icon-chembl']
    'oral':
      'true': ['active', 'u', 'Oral: Yes', 'bottom', 'icon-chembl']
      'false': ['', 'u', 'Oral: No', 'bottom', 'icon-chembl']
    'parenteral':
      'true': ['active', 's', 'Parenteral: Yes', 'bottom', 'icon-chembl']
      'false': ['', 's', 'Parenteral: No', 'bottom', 'icon-chembl']
    'topical':
      'true': ['active', 'm', 'Topical: Yes', 'bottom', 'icon-chembl']
      'false': ['', 'm', 'Topical: No', 'bottom', 'icon-chembl']
    'black_box_warning':
      '0': ['', 'b', 'Black Box: No', 'bottom', 'icon-chembl']
      '1': ['active', 'b', 'Black Box: Yes', 'bottom', 'icon-chembl']
    'availability_type':
      '-2': ['active', 'w', 'Availability: Withdrawn', 'bottom', 'icon-chembl-2']
      '-1': ['', '1', 'Availability: Undefined', 'bottom', 'icon-chembl']
      '0': ['active', '2', 'Availability: Discontinued', 'bottom', 'icon-chembl']
      '1': ['active', '1', 'Availability: Prescription Only', 'bottom', 'icon-chembl']
      '2': ['active', 't', 'Availability: Over the Counter', 'bottom', 'icon-chembl']
    'ro5':
      'true': ['active', '5', 'Rule Of Five: Yes', 'top', 'icon-chembl']
      'false': ['', '5', 'Rule Of Five: No', 'top', 'icon-chembl']
