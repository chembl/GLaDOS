glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Assay Schema
  # --------------------------------------------------------------------------------------------------------------------
  AssaySchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_assay'
      # Default Selected
      [
        '_metadata.organism_taxonomy.l1',
        '_metadata.organism_taxonomy.l2',
        '_metadata.organism_taxonomy.l3',
        'assay_organism',
        '_metadata.assay_generated.type_label',
        'bao_label',
        '_metadata.source.src_description',
        {
          name:'_metadata.assay_generated.confidence_label'
          sort:'asc'
        },
      ],
      # Default Hidden
      [
        'assay_tissue',
        'assay_cell_type',
        'assay_subcellular_fraction',
        'assay_cell_type',
        'assay_strain',
        '_metadata.assay_generated.relationship_label',
      ],
      [

      ]
    )