# View that renders the Assay curation information section
# from the Assay report card
AssayCurationSummaryView = CardView.extend

  initialize: ->
    @model.on 'change', @render, @
    @resource_type = 'Assay'

  render: ->

    target = @model.get('target')

    # listen for the target changes if it exists
    if target?
      target.on 'change', @render, @

    @fillTemplate('BCK-ACS-large')
    @fillTemplate('BCK-ACS-small')
    @showCardContent()


    @initEmbedModal('curation_summary')
    @activateModals()

  fillTemplate: (div_id) ->

    target = @model.get('target')

    div = $(@el).find('#' + div_id)
    template = $('#' + div.attr('data-hb-template'))

    div.html Handlebars.compile(template.html())
      target_type: target.get('target_type')
      pref_name: target.get('pref_name')
      target_chembl_id: target.get('target_chembl_id')


