# View that renders the Approved drugs and clinical candidates section
# from the target report card
# load CardView first!
ApprovedDrugsClinicalCandidatesView = CardView.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @resource_type = 'Target'

  render: ->

    if @collection.size() == 0 and !@collection.getMeta('force_show')
      $('#ApprovedDrugsAndClinicalCandidates').hide()
      return

    @clearTable()
    @clearList()

    @fill_template('ADCCTable-large')
    @fill_template('ADCCUL-small')
    @fillPaginator('ADCCUL-paginator')

    @showVisibleContent()
    @initEmbedModal('approved_drugs_clinical_candidates')
    @activateModals()

    @activatePageSelector();

  clearTable: ->

    $('#ADCCTable-large').empty()

  clearList: ->

    $('#ADCCUL-small').empty()
