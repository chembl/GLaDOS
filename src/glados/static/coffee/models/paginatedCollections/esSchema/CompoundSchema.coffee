glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Compound Schema
  # --------------------------------------------------------------------------------------------------------------------
  CompoundSchema:
    FACETS:
      molecule_type:
        label: 'Molecule Type'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewCategoryFacetingHandler(
          'molecule_type.keyword'
        )
      indication_class:
        label: 'Indication Class'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewCategoryFacetingHandler(
          'indication_class.keyword'
        )
      max_phase:
        label: 'Max Phase'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewCategoryFacetingHandler(
          'max_phase'
        )
