glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Assay Schema
  # --------------------------------------------------------------------------------------------------------------------
  AssaySchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_assay'
      # Default Selected
      [
        '_metadata.assay_generated.type_label',
        'assay_classifications.l1',
        'assay_classifications.l2',
        'assay_classifications.l3',
        '_metadata.organism_taxonomy.l1',
        '_metadata.organism_taxonomy.l2',
        '_metadata.organism_taxonomy.l3',
        {
          property:'assay_organism'
          sort:'asc'
          intervals: 20
        },
        {
          property:'bao_label'
          sort:'asc'
          intervals: 20
        },
        {
          property:'_metadata.source.src_description'
          sort:'asc'
          intervals: 20
        },
        {
          property:'_metadata.assay_generated.confidence_label'
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