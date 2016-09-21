# View that renders the Approved drugs and clinical candidates section
# from the target report card
# load CardView first!
ApprovedDrugsClinicalCandidatesView = CardView.extend(PaginatedViewExt).extend(DownloadViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @resource_type = 'Target'

  events: ->
    # aahhh!!! >(
    return _.extend {}, PaginatedViewExt.events, DownloadViewExt.events

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

  # -----------------------------------------------------------------
  # ---- Downloads
  # -----------------------------------------------------------------

  getFilename: (format) ->

    if format == 'csv'
      return 'ApprovedDrugsClinicalCandidates.csv'
    else if format == 'json'
      return 'ApprovedDrugsClinicalCandidates.json'
    else if format == 'xlsx'
      return 'ApprovedDrugsClinicalCandidates.xlsx'
    else
      return 'file.txt'