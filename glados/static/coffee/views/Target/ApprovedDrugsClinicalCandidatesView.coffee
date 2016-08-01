# View that renders the Approved drugs and clinical candidates section
# from the target report card
# load CardView first!
ApprovedDrugsClinicalCandidatesView = CardView.extend

  initialize: ->
    @collection.on 'reset', @.render, @
    @resource_type = 'Target'

  events:
    'click .page-selector': 'getPage'

  render: ->

    if @collection.size() == 0
      $('#ApprovedDrugsAndClinicalCandidates').hide()
      return

    @clearTable()
    @clearList()

    @fill_template('ADCCTable-large')
    @fill_template('ADCCUL-small')

    @showVisibleContent()
    @initEmbedModal('approved_drugs_clinical_candidates')
    @activateModals()


  fill_template: (elem_id) ->

    elem = $(@el).find('#' + elem_id)
    template = $('#' + elem.attr('data-hb-template'))

    for adcc in @collection.models

      new_row_cont = Handlebars.compile( template.html() )
        molecule_chembl_id: adcc.get('molecule_chembl_id')
        pref_name: adcc.get('pref_name')
        mechanism_of_action: adcc.get('mechanism_of_action')
        max_phase: adcc.get('max_phase')

      elem.append($(new_row_cont))

  clearTable: ->

    $('#ADCCTable-large tr:gt(0)').remove()

  clearList: ->

    $('#ADCCUL-small').empty()

  getPage: (event)->

    clicked = $(event.currentTarget)
    page_num = clicked.attr('data-page')

    current_page = @collection.getMeta('current_page')

    # Don't bother if the user requested the same page as the current one
    if current_page == page_num
      return

    current_page
    $(@el).find('.page-selector').removeClass('active')
    clicked.addClass('active')

    @collection.fetchPage(page_num)
    @showPreloader()
    



