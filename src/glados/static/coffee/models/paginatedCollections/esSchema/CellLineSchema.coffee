glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Target Schema
  # --------------------------------------------------------------------------------------------------------------------
  CellLineSchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_cell_line'
      # Default Selected
      [
        'cell_source_organism',
        'cell_source_tissue',
        'cell_source_tax_id'
      ],
      # Default Hidden
      [
      ],
      [

      ]
    )
