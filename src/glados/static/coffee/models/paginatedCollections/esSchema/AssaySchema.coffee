glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Assay Schema
  # --------------------------------------------------------------------------------------------------------------------
  AssaySchema:
    FACETS_GROUPS:
      assay_type:
        label: 'Type'
        show: true
        position: 1
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','assay_type'
        )
      assay_category:
        label: 'Category'
        show: true
        position: 2
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','assay_category'
        )
      assay_cell_type:
        label: 'Cell Type'
        show: true
        position: 3
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','assay_cell_type'
        )
      assay_organism:
        label: 'Organism'
        show: true
        position: 4
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','assay_organism'
        )
      assay_strain:
        label: 'Strain'
        show: true
        position: 5
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','assay_strain'
        )
      assay_tissue:
        label: 'Tissue'
        show: true
        position: 6
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','assay_tissue'
        )
      bao_format:
        label: 'BAO Format'
        show: true
        position: 7
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','bao_format'
        )
      confidence_score:
        label: 'Confidence Score'
        show: true
        position: 8
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','confidence_score'
        )
      src_id:
        label: 'Source'
        show: true
        position: 9
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','src_id'
        )