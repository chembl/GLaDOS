glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Assay Schema
  # --------------------------------------------------------------------------------------------------------------------
  AssaySchema:
    FACETS_GROUPS:
      assay_type:
        label: 'Type'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','assay_type'
        )
      assay_category:
        label: 'Category'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','assay_category'
        )
      assay_cell_type:
        label: 'Cell Type'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','assay_cell_type'
        )
      assay_organism:
        label: 'Organism'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','assay_organism'
        )
      assay_strain:
        label: 'Strain'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','assay_strain'
        )
      assay_tissue:
        label: 'Tissue'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','assay_tissue'
        )
      bao_format:
        label: 'BAO Format'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','bao_format'
        )
      confidence_score:
        label: 'Confidence Score'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','confidence_score'
        )
      src_id:
        label: 'Source'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_assay','src_id'
        )