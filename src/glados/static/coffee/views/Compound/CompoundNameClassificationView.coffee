# View that renders the Compound Name and Classification section
# from the compound report card
# load CardView first!
# also make sure the html can access the handlebars templates!
CompoundNameClassificationView = CardView.extend

  initialize: ->

    CardView.prototype.initialize.call(@, arguments)
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Compound'
    @showSection()

  render: ->

    @renderTitle()
    @renderPrefName()
    @renderMaxPhase()
    @renderMolFormula()
    @renderSynonymsAndTradeNames()
    @renderMolType()

    # until here, all the visible content has been rendered.
    @showCardContent()

    @initEmbedModal('name_and_classification', @model.get('molecule_chembl_id'))
    @activateTooltips()
    @activateModals()

    # this is required to render correctly the molecular formulas.
    # it comes from the easychem.js library
    ChemJQ.autoCompile()

  renderTitle: ->
    $(@el).find('#Bck-CHEMBL_ID').text(@model.get('molecule_chembl_id'))

  renderPrefName: ->
    name = @model.get('pref_name')
    text = if name != null then name else 'Undefined'

    rendered = Handlebars.compile($('#Handlebars-Compound-NameAndClassification-renderPrefName').html())
      name: text
      undef: name == null

    $(@el).find('#Bck-PREF_NAME').html(rendered)

  renderMolType: -> $(@el).find('#Bck-MOLTYPE').html(@model.get('molecule_type'))

  renderMaxPhase: ->
    phase = @model.get('max_phase')
    withdrawn = @model.get('withdrawn_flag')
    phase_class = 'comp-phase-' + phase

    description = switch
      when phase == 0 then 'Preclinical'
      when phase == 1 then 'Phase I'
      when phase == 2 then 'Phase II'
      when phase == 3 then 'Phase III'
      when phase == 4 then 'Approved'
      else
        'Undefined'

    tooltip_text = switch
      when phase == 0 then 'Phase 0: The compound has not yet reached phase I clinical trials ' +
        '(preclinical/research compound).'
      when phase == 1 then 'Phase 1: The compound has reached phase I clinical trials (safety studies, usually ' +
        'with healthy volunteers).'
      when phase == 2 then 'Phase 2: The compound has reached phase II clinical trials (preliminary studies of ' +
        'effectiveness).'
      when phase == 3 then 'Phase 3: The compound has reached phase III clinical trials (larger studies of safety and ' +
        'effectiveness).'
      when phase == 4 then 'Phase 4: The compound has been approved in at least one country or area.'
      else
        'Undefined'

    withdrawn_text = 'The compound has been withdrawn in some countries. Click to see more'


    template = Handlebars.compile($('#Handlebars-Compound-NameAndClassification-renderMaxPhase').html())
    rendered = template
      class: phase_class
      text: phase
      desc: description
      tooltip: tooltip_text
      withdrawn: withdrawn
      withdrawn_text: withdrawn_text


    $(@el).find('#Bck-MAX_PHASE').html(rendered)
    #Initialize materialize tooltip
    $(@el).find('#Bck-MAX_PHASE').find('.tooltipped').tooltip()

  renderMolFormula: ->

    if @model.get('structure_type') == 'SEQ' or @model.get('structure_type') == 'NONE'
      $(@el).find('#Bck-MOLFORMULA').parent().parent().hide()
      $(@el).find('#Bck-FULLMWT').parent().parent().hide()
    else
      molformula = @model.get('molecule_properties')['full_molformula']
      $(@el).find('#Bck-MOLFORMULA').text(molformula)
      molWt = @model.get('molecule_properties')['full_mwt']
      $(@el).find('#Bck-FULLMWT').text("#{molWt}")

  renderSynonymsAndTradeNames: ->

    onlySynonymsList = @model.getSynonyms()

    if onlySynonymsList.length == 0

      $(@el).find('#CompNameClass-synonyms').parent().parent().parent().hide()

    else

      syn_rendered = Handlebars.compile($('#Handlebars-Compound-NameAndClassification-synonyms').html())
        items: onlySynonymsList

      $(@el).find('#CompNameClass-synonyms').html(syn_rendered)


    onlyTradeNamesList = @model.getTradenames()

    if onlyTradeNamesList.length == 0

      $(@el).find('#CompNameClass-tradenames').parent().parent().parent().hide()

    else

      tn_rendered = Handlebars.compile($('#Handlebars-Compound-NameAndClassification-tradenames').html())
        items: onlyTradeNamesList

      $(@el).find('#CompNameClass-tradenames').html(tn_rendered)
