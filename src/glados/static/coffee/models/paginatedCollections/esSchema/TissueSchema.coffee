glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Target Schema
  # --------------------------------------------------------------------------------------------------------------------
  TissueSchema:
    FACETS_GROUPS:
      efo_id:
        label: 'EFO ID'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_tissue','efo_id'
        )
      uberon_id:
        label: 'UBERON ID'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_tissue','uberon_id'
        )
