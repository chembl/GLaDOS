glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Target Schema
  # --------------------------------------------------------------------------------------------------------------------
  TargetSchema:
    FACETS_GROUPS:
      organism:
        label: 'Organism'
        show: true
        position: 1
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_target','organism'
        )
      target_type:
        label: 'Target Type'
        show: true
        position: 2
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_target','target_type'
        )
      related_compounds_count:
        label: '# Related Compounds'
        show: true
        position: 3
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_target','_metadata.related_compounds.count'
        )
      activity_count:
        label: '# Bioactivities'
        show: true
        position: 4
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_target','_metadata.activity_count'
        )
