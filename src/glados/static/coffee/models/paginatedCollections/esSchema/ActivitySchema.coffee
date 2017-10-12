glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Activity Schema
  # --------------------------------------------------------------------------------------------------------------------
  ActivitySchema:
    FACETS_GROUPS:
      standard_value:
        label: 'Standard Value'
        show: true
        position: 1
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_activity','standard_value'
        )
      standard_type:
        label: 'Standard Type'
        show: true
        position: 2
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_activity','standard_type'
        )
      target_organism:
        label: 'Target Organism'
        show: true
        position: 3
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_activity','target_organism'
        )