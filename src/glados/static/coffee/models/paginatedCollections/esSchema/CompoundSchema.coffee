glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Compound Schema
  # --------------------------------------------------------------------------------------------------------------------
  CompoundSchema:
    FACETS_GROUPS:
      molecule_type:
        label: 'Molecule Type'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','molecule_type'
        )
      indication_class:
        label: 'Indication Class'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','indication_class'
        )
      max_phase:
        label: 'Max Phase'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','max_phase'
        )
      full_mwt:
        label: 'Molecular Weight'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','molecule_properties.full_mwt'
        )
      hba:
        label: 'H.B.Acceptors'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','molecule_properties.hba'
        )
      hbd:
        label: 'H.B. Donors'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','molecule_properties.hbd'
        )
