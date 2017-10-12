glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Document Schema
  # --------------------------------------------------------------------------------------------------------------------
  DocumentSchema:
    FACETS_GROUPS:
      doc_type:
        label: 'Type'
        show: true
        position: 1
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_document','doc_type'
        )
      journal:
        label: 'Journal'
        show: true
        position: 2
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_document','journal'
        )
      year:
        label: 'Year'
        show: true
        position: 3
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_document','year'
        )
      issue:
        label: 'Issue'
        show: true
        position: 4
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_document','issue'
        )
      volume:
        label: 'Volume'
        show: true
        position: 5
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_document','volume'
        )
