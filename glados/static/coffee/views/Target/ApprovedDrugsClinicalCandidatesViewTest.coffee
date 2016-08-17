# View that renders the Approved drugs and clinical candidates section
# from the target report card
# load CardView first!
ApprovedDrugsClinicalCandidatesViewTest = CardView.extend

  initialize: ->
    @collection.on 'reset', @.render, @
    @resource_type = 'Target'

  render: ->

    if @collection.size() == 0
      $('#ApprovedDrugsAndClinicalCandidates').hide()
      return

    $('#example_target').DataTable()

    @showVisibleContent()
    @initEmbedModal('approved_drugs_clinical_candidates')
    @activateModals()
    @activatePageSelector()






    



