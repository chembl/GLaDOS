glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Document Schema
  # --------------------------------------------------------------------------------------------------------------------
  DocumentSchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_document'
      # Default Selected
      [
        'doc_type',
        'journal',
        '_metadata.source.src_description'
        'year',
      ],
      # Default Hidden
      [
      ],
      [

      ]
    )
