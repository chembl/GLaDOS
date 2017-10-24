glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Target Schema
  # --------------------------------------------------------------------------------------------------------------------
  TargetSchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_target'
    )
