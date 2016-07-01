# View that renders the Cell Line basic information section
# from the cell line report card
# load CardView first!
# also make sure the html can access the handlebars templates!
CellLineBasicInformationView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Cell Line'

  render: ->
    @render_for_large()
    @render_for_small()

    @showVisibleContent()
    @initEmbedModal('basic_information')
    @activateModals()

  render_for_large: ->

    table_large = $(@el).find('#BCK-CBI-large')
    template = $('#' + table_large.attr('data-hb-template'))
    
    table_large.html Handlebars.compile(template.html())
      chembl_id: @model.get('cell_chembl_id')
      name: @model.get('cell_name')
      description: @model.get('cell_description')
      tissue: @model.get('cell_source_tissue')
      organism: @model.get('cell_source_organism')
      tax_id: @model.get('cell_source_tax_id')
      clo_id: @model.get('clo_id')
      efo_id: @model.get('efo_id')
      cellosaurus_id: @model.get('cellosaurus_id')

  render_for_small: ->

    table_large = $(@el).find('#BCK-CBI-small')
    template = $('#' + table_large.attr('data-hb-template'))

    table_large.html Handlebars.compile(template.html())
      chembl_id: @model.get('cell_chembl_id')
      name: @model.get('cell_name')
      description: @model.get('cell_description')
      tissue: @model.get('cell_source_tissue')
      organism: @model.get('cell_source_organism')
      tax_id: @model.get('cell_source_tax_id')
      clo_id: @model.get('clo_id')
      efo_id: @model.get('efo_id')
      cellosaurus_id: @model.get('cellosaurus_id')