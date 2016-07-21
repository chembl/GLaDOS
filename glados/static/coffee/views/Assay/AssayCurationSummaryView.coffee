# View that renders the Assay curation information section
# from the Assay report card
AssayCurationSummaryView = CardView.extend

  initialize: ->
    @model.on 'change', @render, @

  render: ->

    target = @model.get('target')

    # listen for the target changes if it is ready
    if target?
      target.on 'change', @render, @

    @fill_template('BCK-ACS-large')
    @showVisibleContent()

  fill_template: (div_id) ->

    target = @model.get('target')

    div = $(@el).find('#' + div_id)
    template = $('#' + div.attr('data-hb-template'))

    div.html Handlebars.compile(template.html())
      target_type: target.get('target_type')
      pref_name: target.get('pref_name')
      target_chembl_id: target.get('target_chembl_id')


