# View that renders the Compound Name and Classification section
# from the compound report card
CompoundNameClassificationView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showErrorCard, @

  showErrorCard: ->
    $(@el).children('.card-preolader-to-hide').hide()
    $(@el).children('.card-load-error').show()

  render: ->
    $(@el).children('.card-preolader-to-hide').hide()
    $(@el).children(':not(.card-preolader-to-hide, .card-load-error)').show()

    attributes = @model.toJSON()
    @renderTitle()
    @renderPrefName()
    @renderMaxPhase()
    @renderMolFormula()
    @renderImage()
    @renderSynonymsAndTradeNames()

    # this is required to render correctly the molecular formulas.
    # it comes from the easychem.js library
    ChemJQ.autoCompile()

  renderTitle: ->

    $(@el).find('#Bck-CHEMBL_ID').text(@model.get('molecule_chembl_id'))

  renderPrefName: ->

    $(@el).find('#Bck-PREF_NAME').text(@model.get('pref_name'))

  renderMaxPhase: ->

    phase = @model.get('max_phase')
    phase_class = 'comp-phase-' + phase

    if phase == 4
      phase += ' (Approved)'

    source = '<span class="{{class}}"> {{text}} </span>'

    template = Handlebars.compile(source)
    rendered = template
      class: phase_class
      text: phase

    $(@el).find('#Bck-MAX_PHASE').html(rendered)

  renderMolFormula: ->

    $(@el).find('#Bck-MOLFORMULA').text(@model.get('molecule_properties')['full_molformula'])

  renderImage: ->

    img_url = 'https://www.ebi.ac.uk/chembl/api/data/image/' + @model.get('molecule_chembl_id')
    $(@el).find('#Bck-COMP_IMG').attr('src', img_url)

  renderSynonymsAndTradeNames: ->

    all_syns = @model.get('molecule_synonyms')
    unique_synonyms = new Set()
    trade_names = new Set()

    $.each all_syns, (index, value) ->

      if value.syn_type == 'TRADE_NAME'
        trade_names.add(value.synonyms)

      unique_synonyms.add(value.synonyms)

    synonyms_source = '{{#each items}}' +
                        ' <span class="CNC-chip-syn">{{ this }}</span> ' +
                        '{{/each}}'

    syn_rendered = Handlebars.compile(synonyms_source)
      items: Array.from(unique_synonyms)

    $(@el).find('#CompNameClass-synonyms').html(syn_rendered)

    tradenames_source = '{{#each items}}' +
                        ' <span class="CNC-chip-tn">{{ this }}</span> ' +
                        '{{/each}}'

    tn_rendered = Handlebars.compile(tradenames_source)
      items: Array.from(trade_names)

    $(@el).find('#CompNameClass-tradenames').html(tn_rendered)










