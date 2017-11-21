# View that renders the Cell Line basic information section
# from the cell line report card
# load CardView first!
# also make sure the html can access the handlebars templates!
CellLineBasicInformationView = CardView.extend

  initialize: ->
    CardView.prototype.initialize.call(@, arguments)
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Cell Line'
    @showSection()

  render: ->

    @fillTemplate('BCK-CBI-large')
    @fillTemplate('BCK-CBI-small')

    @showCardContent()
    @initEmbedModal('basic_information', @model.get('cell_chembl_id'))
    @activateModals()

  fillTemplate: (div_id) ->

    div = $(@el).find('#' + div_id)
    template = $('#' + div.attr('data-hb-template'))

    div.html Handlebars.compile(template.html())
      chembl_id: @model.get('cell_chembl_id')
      name: @model.get('cell_name')
      description: @model.get('cell_description')
      tissue: @model.get('cell_source_tissue')
      organism: @model.get('cell_source_organism')
      tax_id: @model.get('cell_source_tax_id')
      clo_id: @model.get('clo_id')
      efo_id: @model.get('efo_id')
      cellosaurus_id: @model.get('cellosaurus_id')
      cl_lincs_id: @model.get('cl_lincs_id')

