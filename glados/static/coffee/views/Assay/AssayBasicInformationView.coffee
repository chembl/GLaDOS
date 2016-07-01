# View that renders the Assay basic information section
# from the Assar report card
# load CardView first!
# also make sure the html can access the handlebars templates!
AssayBasicInformationView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Assay'

  render: ->

    @fill_template('BCK-ABI-large')
    @fill_template('BCK-ABI-small')
    @showVisibleContent()


  fill_template: (div_id) ->

    table_large = $(@el).find('#' + div_id)
    template = $('#' + table_large.attr('data-hb-template'))

    table_large.html Handlebars.compile(template.html())
      chembl_id: @model.get('assay_chembl_id')
      type: @model.get('assay_type_description')
      description: @model.get('description')
      format: @model.get('bao_format')
      organism: @model.get('assay_organism')
      strain: @model.get('assay_strain')
      cell_type: @model.get('cell_type')
      subcellular_fraction: @model.get('assay_subcellular_fraction')