# View that renders the Assay curation information section
# from the Assay report card
AssayCurationSummaryView = CardView.extend

  initialize: ->
    CardView.prototype.initialize.call(@, arguments)
    @model.on 'change', @render, @
    @resource_type = 'Assay'
    @showSection()

  render: ->

    @fillTemplate('BCK-ACS-large')
    @fillTemplate('BCK-ACS-small')
    @showCardContent()

    @initEmbedModal('curation_summary', @model.get('assay_chembl_id'))
    @activateModals()

  fillTemplate: (div_id) ->

    $elem = $(@el).find('#' + div_id)
    glados.Utils.fillContentForElement $elem,
      target_type: @model.get('target_type')
      pref_name: @model.get('pref_name')
      target_chembl_id: @model.get('target_chembl_id')
      report_card_url: @model.get('report_card_url')


