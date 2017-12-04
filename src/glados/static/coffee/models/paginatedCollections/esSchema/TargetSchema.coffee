glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Target Schema
  # --------------------------------------------------------------------------------------------------------------------
  TargetSchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_target',
      # Default Selected
      [
        '_metadata.organism_taxonomy.l1',
        '_metadata.organism_taxonomy.l2',
        '_metadata.organism_taxonomy.l3',
        'organism',
        '_metadata.protein_classification.l1',
        '_metadata.protein_classification.l2',
        'target_type',
        '_metadata.related_compounds.count',
        '_metadata.activity_count',
      ],
      # Default Hidden
      [
      ],
      [

      ]
    )
