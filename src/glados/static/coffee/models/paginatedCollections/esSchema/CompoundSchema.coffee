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
      therapeutic_flag:
        label: 'Therapeutic'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','therapeutic_flag'
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
      related_targets_count:
        label: '# Related Targets'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','_metadata.related_targets.count'
        )
      activity_count:
        label: '# Bioactivities'
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','_metadata.activity_count'
        )
