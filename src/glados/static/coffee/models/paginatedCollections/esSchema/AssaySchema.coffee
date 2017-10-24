glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Assay Schema
  # --------------------------------------------------------------------------------------------------------------------
  AssaySchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_assay'
      [
        'assay_organism',
        'bao_format',
        'src_id',
        'confidence_score',
      ],
      [
        'assay_type',
        'assay_tissue',
        'assay_cell_type',
        'assay_subcellular_fraction',
        'assay_cell_type',
      ],
      [

      ]
    )