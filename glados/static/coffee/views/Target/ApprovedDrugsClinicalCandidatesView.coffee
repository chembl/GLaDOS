# View that renders the Approved drugs and clinical candidates section
# from the target report card
# load CardView first!
ApprovedDrugsClinicalCandidatesView = CardView.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @resource_type = 'Target'

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
