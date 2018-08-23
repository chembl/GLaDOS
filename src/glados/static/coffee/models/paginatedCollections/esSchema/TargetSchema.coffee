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
        {
          property:'organism'
          sort:'asc'
          intervals: 20
        },
        '_metadata.protein_classification.l1',
        '_metadata.protein_classification.l2',
        {
          property:'target_type'
          sort:'asc'
          intervals: 20
        },
        '_metadata.related_compounds.count',
        '_metadata.related_activities.count',
      ],
      # Default Hidden
      [
        '_metadata.protein_classification.l3',
        '_metadata.protein_classification.l4',
      ],
      [

      ]
    )
