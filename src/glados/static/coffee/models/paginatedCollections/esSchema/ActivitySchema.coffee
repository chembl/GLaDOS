glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Activity Schema
  # --------------------------------------------------------------------------------------------------------------------
  ActivitySchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_activity'
    )