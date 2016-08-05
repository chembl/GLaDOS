# View that renders the Approved drugs and clinical candidates section
# from the target report card
# load CardView first!
ApprovedDrugsClinicalCandidatesView = CardView.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @resource_type = 'Target'

  events:
    'click .page-selector': 'getPage'
    'change .change-page-size': 'changePageSize'
    'click .sort': 'sortCollection'
    'input .search': 'setSearch'

  render: ->

    if @collection.size() == 0
      $('#ApprovedDrugsAndClinicalCandidates').hide()
      return

    @clearTable()
    @clearList()

    @fill_template('ADCCTable-large')
    @fill_template('ADCCUL-small')
    @fillPaginator()

    @showVisibleContent()
    @initEmbedModal('approved_drugs_clinical_candidates')
    @activateModals()

    $('select').material_select();

  fill_template: (elem_id) ->

    elem = $(@el).find('#' + elem_id)
    template = $('#' + elem.attr('data-hb-template'))

    if elem_id == 'ADCCTable-large'

      header_template = $('#Handlebars-Target-TableHeader')
      header_row_cont = Handlebars.compile( header_template.html() )
        columns: @collection.getMeta('columns')


      elem.append($(header_row_cont))



    for adcc in @collection.getCurrentPage()

      new_row_cont = Handlebars.compile( template.html() )
        molecule_chembl_id: adcc.get('molecule_chembl_id')
        pref_name: adcc.get('pref_name')
        mechanism_of_action: adcc.get('mechanism_of_action')
        max_phase: adcc.get('max_phase')

      elem.append($(new_row_cont))

  fillPaginator: ->

    elem = $(@el).find('#ADCCUL-paginator')
    template = $('#' + elem.attr('data-hb-template'))

    current_page = @collection.getMeta('current_page')
    records_in_page = @collection.getMeta('records_in_page')
    page_size = @collection.getMeta('page_size')

    first_record = (current_page - 1) * page_size
    last_page = first_record + records_in_page

    pages = (num for num in [1..@collection.getMeta('total_pages')])

    elem.html Handlebars.compile(template.html())
      pages: pages
      records_showing: first_record + '-' + last_page
      total_records: @collection.getMeta('total_records')

    @activateCurrentPageButton()
    @enableDisableNextLastButtons()

  clearTable: ->

    $('#ADCCTable-large').empty()

  clearList: ->

    $('#ADCCUL-small').empty()
