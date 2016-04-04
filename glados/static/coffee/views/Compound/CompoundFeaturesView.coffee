# View that renders the Molecule Features section
# from the compound report card
CompoundFeaturesView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @

  render: ->
    @renderProperty('Bck-MolType', 'molecule_type')
    @renderProperty('Bck-FirstInClass', 'first_in_class')

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

  getMolFeatureDetails: (feature, position) ->
    return @molFeatures[feature][@model.get(feature)][position]

  # active class,filename, tooltip, mobile description
  molFeatures:
    'molecule_type':
      'Small molecule': ['active', 'mt_small_molecule', 'Molecule Type: small molecule', 'Small Molecule']
      'Antibody': ['active', 'mt_antibody', 'Molecule Type: Antibody', 'Antibody']
      'Enzyme': ['active', 'mt_enzyme', 'Molecule Type: Enzyme', 'Enzyme']
    'first_in_class':
      '0': ['', 'first_in_class', 'First in Class: No', 'First in Class']
      '1': ['active', 'first_in_class', 'First in Class: Yes', 'First in Class']
