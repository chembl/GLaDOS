glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Target Schema
  # --------------------------------------------------------------------------------------------------------------------
  CellLineSchema:
    FACETS_GROUPS:
      cell_source_organism:
        label: 'Source Organism'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_cell_line','cell_source_organism'
        )
      cell_source_tax_id:
        label: 'Tax ID'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_cell_line','cell_source_tax_id'
        )
      cell_source_tissue:
        label: 'Source Tissue'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_cell_line','cell_source_tissue'
        )
      cellosaurus_id:
        label: 'Cellosaurus ID'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_cell_line','cellosaurus_id'
        )
      cl_lincs_id:
        label: 'CL Lincs ID'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_cell_line','cl_lincs_id'
        )
      clo_id:
        label: 'CLO ID'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_cell_line','clo_id'
        )
      efo_id:
        label: 'EFO ID'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_cell_line','efo_id'
        )
