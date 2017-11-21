glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Assay Schema
  # --------------------------------------------------------------------------------------------------------------------
  AssaySchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_assay'
      # Default Selected
      [
        'assay_organism',
        'bao_label',
        '_metadata.source.src_description',
        'confidence_score',
        'confidence_description',
      ],
      # Default Hidden
      [
        'assay_type',
        'assay_type_description',
        'assay_tissue',
        'assay_cell_type',
        'assay_subcellular_fraction',
        'assay_cell_type',
        'assay_strain',
        'assay_tax_id',
        'relationship_type',
        'relationship_description',
      ],
      [

      ]
    )