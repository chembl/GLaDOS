# View that renders the Approved drugs and clinical candidates section
# from the target report card
# load CardView first!
ApprovedDrugsClinicalCandidatesView = CardView.extend(DownloadViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @resource_type = 'Target'
    @paginatedView = PaginatedView.getNewTablePaginatedView(@collection, @el)

    @initEmbedModal('approved_drugs_clinical_candidates')
    @activateModals()


  events: ->
    # aahhh!!! >(
    return _.extend {}, PaginatedViewExt.events, DownloadViewExt.events

  render: ->

    if @collection.size() == 0 and !@collection.getMeta('force_show')
      $('#ApprovedDrugsAndClinicalCandidates').hide()
      return

    @showCardContent()

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