# View that renders the Assay basic information section
# from the Assay report card
AssayBasicInformationView = CardView.extend

  initialize: ->

    CardView.prototype.initialize.call(@, arguments)
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Assay'
    @showSection()

  render: ->

    @fillTemplate('BCK-ABI-large')
    @fillTemplate('BCK-ABI-small')
    @showCardContent()

    @initEmbedModal('basic_information', @model.get('assay_chembl_id'))
    @activateModals()


  fillTemplate: (div_id) ->

    $elem = $(@el).find('#' + div_id)

    console.log 'fillTemplate: '
    documentAttributes = @model.get('_metadata').document_data
    referenceText = Document.getFormattedReference(documentAttributes)
    referenceLink = 'http://dx.doi.org/' + encodeURIComponent(documentAttributes.doi)
    console.log 'documentAttributes: ', documentAttributes

    glados.Utils.fillContentForElement $elem,
      chembl_id: @model.get('assay_chembl_id')
      type: @model.get('assay_type_description')
      description: @model.get('description')
      format: @model.get('bao_format')
      reference_text: referenceText
      reference_link: referenceLink
      organism: @model.get('assay_organism')
      strain: @model.get('assay_strain')
      tissue: @model.get('assay_tissue')
      cell_type: @model.get('assay_cell_type')
      subcellular_fraction: @model.get('assay_subcellular_fraction')
      target_chembl_id: @model.get('target_chembl_id')
      target_link: @model.get('target_link')
      document_chembl_id: @model.get('document_chembl_id')
      document_link: @model.get('document_link')
      cell_chembl_id: @model.get('cell_chembl_id')
      cell_link: @model.get('cell_link')
      tissue_chembl_id: @model.get('tissue_chembl_id')
      tissue_link: @model.get('tissue_link')