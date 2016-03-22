# View that renders the Compound Name and Classification section
# from the compound report card
CompoundNameClassificationView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showErrorCard, @

  showErrorCard: (model, xhr, options)->
    $(@el).children('.card-preolader-to-hide').hide()

    if xhr.status == 404
      error_msg = 'No compound found with id ' + @model.get('molecule_chembl_id')
    else
      error_msg = 'There was an error while loading the compound (' + xhr.status + ' ' + xhr.statusText + ')'

    source = '<i class="fa fa-exclamation-circle"></i> {{msg}}'
    rendered = Handlebars.compile(source)
      msg: error_msg

    $(@el).children('.card-load-error').find('#Bck-errormsg').html(rendered)

    $(@el).children('.card-load-error').show()

  render: ->

    @renderImage()
    @renderTitle()
    @renderPrefName()
    @renderMaxPhase()
    @renderMolFormula()
    @renderSynonymsAndTradeNames()

    # until here, all the visible content has been rendered.
    $(@el).children('.card-preolader-to-hide').hide()
    $(@el).children(':not(.card-preolader-to-hide, .card-load-error)').show()

    @initEmbedModal()
    @renderModalPreview()
    @initDownloadButtons()
    @initZoomModal()

    # this is required to render correctly the molecular formulas.
    # it comes from the easychem.js library
    ChemJQ.autoCompile()

  renderTitle: ->
    $(@el).find('#Bck-CHEMBL_ID').text(@model.get('molecule_chembl_id'))

  renderPrefName: ->
    name = @model.get('pref_name')
    text = if name != null then name else 'Undefined'

    source = '<span> {{#if undef}}<i>{{/if}} {{name}} {{#if undef}}</i>{{/if}} </span>'
    rendered = Handlebars.compile(source)
      name: text
      undef: name == null

    $(@el).find('#Bck-PREF_NAME').html(rendered)

  renderMaxPhase: ->
    phase = @model.get('max_phase')
    phase_class = 'comp-phase-' + phase

    show_phase = phase != 0

    description = switch
      when phase == 1 then 'Phase I'
      when phase == 2 then 'Phase II'
      when phase == 3 then 'Phase III'
      when phase == 4 then 'Approved'
      else
        'Undefined'

    tooltip_text = switch
      when phase == 0 then 'Phase 0: Exploratory study involving very limited human exposure to the drug, with no ' +
        'therapeutic or diagnostic goals (for example, screening studies, microdose studies)'
      when phase == 1 then 'Phase 1: Studies that are usually conducted with healthy volunteers and that emphasize ' +
        'safety. The goal is to find out what the drug\'s most frequent and serious adverse events are and, often, ' +
        'how the drug is metabolized and excreted.'
      when phase == 2 then 'Phase 2: Studies that gather preliminary data on effectiveness (whether the drug works ' +
        'in people who have a certain disease or condition). For example, participants receiving the drug may be ' +
        'compared to similar participants receiving a different treatment, usually an inactive substance, called a ' +
        'placebo, or a different drug. Safety continues to be evaluated, and short-term adverse events are studied.'
      when phase == 3 then 'Phase 3: Studies that gather more information about safety and effectiveness by studying ' +
        'different populations and different dosages and by using the drug in combination with other drugs.'
      when phase == 4 then 'Phase 4: Studies occurring after FDA has approved a drug for marketing. These including ' +
        'postmarket requirement and commitment studies that are required of or agreed to by the study sponsor. These ' +
        'studies gather additional information about a drug\'s safety, efficacy, or optimal use.'
      else
        'Undefined'

    source =
      '<span class="{{class}}"> {{text}} </span>' +
        '{{#if show_phase}}' +
        '  <span class="{{class}}"> {{desc}} </span>' +
        '{{/if}}' +
        '<span class="chembl-help">' +
        ' <sub><span class="icon-help hoverable tooltipped indigo-text" data-tooltip="{{tooltip}}" data-position="top"></span></sub>' +
        '</span>'


    template = Handlebars.compile(source)
    rendered = template
      class: phase_class
      text: phase
      desc: description
      show_phase: show_phase
      tooltip: tooltip_text

    $(@el).find('#Bck-MAX_PHASE').html(rendered)
    #Initialize materialize tooltip
    $(@el).find('#Bck-MAX_PHASE').find('.tooltipped').tooltip()

  renderMolFormula: ->
    if @model.get('structure_type') == 'SEQ'
      $(@el).find('#Bck-MOLFORMULA').parent().parent().hide()
    else
      $(@el).find('#Bck-MOLFORMULA').text(@model.get('molecule_properties')['full_molformula'])

  renderImage: ->
    if @model.get('structure_type') == 'NONE'
      img_url = '/static/img/structure_not_available.png'
    else if @model.get('structure_type') == 'SEQ'
      img_url = '/static/img/protein_structure.png'
    else
      img_url = 'https://www.ebi.ac.uk/chembl/api/data/image/' + @model.get('molecule_chembl_id') + '.svg'

    img = $(@el).find('#Bck-COMP_IMG')

    # protein_structure is used when the molecule has a very complex structure that can not be shown in an image.
    # not_available is when the compound has no structure to show.
    # not_found is when there was an error loading the image
    img.error ->
      img.attr('src', '/static/img/structure_not_found.png')

    img.attr('src', img_url)

  renderSynonymsAndTradeNames: ->
    all_syns = @model.get('molecule_synonyms')
    unique_synonyms = new Set()
    trade_names = new Set()

    $.each all_syns, (index, value) ->
      if value.syn_type == 'TRADE_NAME'
        trade_names.add(value.synonyms)

    # I had to make 2 iterations because the keyword delete has some issues in coffesscript
    $.each all_syns, (index, value) ->
      if value.syn_type != 'TRADE_NAME' and not trade_names.has(value.synonyms)
        unique_synonyms.add(value.synonyms)

    if unique_synonyms.size == 0

      $(@el).find('#CompNameClass-synonyms').parent().parent().parent().hide()

    else
      synonyms_source = '{{#each items}}' +
        ' <span class="CNC-chip-syn">{{ this }}</span> ' +
        '{{/each}}'

      syn_rendered = Handlebars.compile(synonyms_source)
        items: Array.from(unique_synonyms)

      $(@el).find('#CompNameClass-synonyms').html(syn_rendered)


    if trade_names.size == 0

      $(@el).find('#CompNameClass-tradenames').parent().parent().parent().hide()

    else
      tradenames_source = '{{#each items}}' +
        ' <span class="CNC-chip-tn">{{ this }}</span> ' +
        '{{/each}}'

      tn_rendered = Handlebars.compile(tradenames_source)
        items: Array.from(trade_names)

      $(@el).find('#CompNameClass-tradenames').html(tn_rendered)

  initEmbedModal: ->

    modal = $(@el).find('#CNC-embed-modal')
    code_elem = modal.find('code')

    source = '<object ' +
             'data="http://glados-ebitest.rhcloud.com//compound_report_card/{{chembl_id}}/embed/name_and_classification/" ' +
             'width="360px" height="600px"></object>'

    rendered = Handlebars.compile(source)
      chembl_id: @model.get('molecule_chembl_id')

    code_elem.text(rendered)

  renderModalPreview: ->

    modal = $(@el).find('#CNC-embed-modal')
    preview_elem = modal.find('.embed-preview')

    code_elem = modal.find('code')
    code_to_preview = code_elem.text()

    preview_elem.html(code_to_preview)

  initDownloadButtons: ->

    img_url = 'https://www.ebi.ac.uk/chembl/api/data/image/' + @model.get('molecule_chembl_id')
    $('.CNC-download-png').attr('href', img_url + '.png')
    $('.CNC-download-png').attr('download', @model.get('molecule_chembl_id') + '.png')

    $('.CNC-download-svg').attr('href', img_url + '.svg')
    $('.CNC-download-svg').attr('download', @model.get('molecule_chembl_id') + '.svg')

  initZoomModal: ->

    modal = $(@el).find('#CNC-zoom-modal')

    title = modal.find('h3')
    title.text(@model.get('molecule_chembl_id'))

    img = modal.find('img')
    img.attr('src', $(@el).find('#Bck-COMP_IMG').attr('src'))
    img.attr('alt', 'Structure of ' + @model.get('molecule_chembl_id'))













