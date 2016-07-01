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

    @initEmbedModal('basic_information')
    @activateModals()


  fill_template: (div_id) ->

    div = $(@el).find('#' + div_id)
    template = $('#' + div.attr('data-hb-template'))

    div.html Handlebars.compile(template.html())
      chembl_id: @model.get('assay_chembl_id')
      type: @model.get('assay_type_description')
      description: @model.get('description')
      format: @model.get('bao_format')
      organism: @model.get('assay_organism')
      strain: @model.get('assay_strain')
      tissue: @model.get('assay_tissue')
      cell_type: @model.get('assay_cell_type')
      subcellular_fraction: @model.get('assay_subcellular_fraction')