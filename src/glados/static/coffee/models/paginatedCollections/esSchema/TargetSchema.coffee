glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Target Schema
  # --------------------------------------------------------------------------------------------------------------------
  TargetSchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_target',
      # Default Selected
      [
        'organism',
        'target_type',
        '_metadata.related_compounds.count',
        '_metadata.activity_count',
      ],
      # Default Hidden
      [
        'tax_id'
      ],
      [

      ]
    )
