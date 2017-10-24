glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Compound Schema
  # --------------------------------------------------------------------------------------------------------------------
  CompoundSchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_molecule',
      [
        'molecule_type',
        'max_phase',
        'molecule_properties.num_ro5_violations',
        'molecule_properties.full_mwt',
        'molecule_properties.alogp',
        '_metadata.related_targets.count',
        '_metadata.activity_count',
      ],
      [
        'molecule_properties.psa',
        'molecule_properties.hba',
        'molecule_properties.hbd',
        'molecule_properties.rtb',
        'molecule_properties.qed_weighted',
        'molecule_properties.acd_logd',
        'molecule_properties.molecular_species',
        'molecule_properties.num_lipinski_ro5_violations',
        'therapeutic_flag',
        'atc_classifications',
        'availability_type',
        'oral',
        'parenteral',
        'topical',
        'black_box_warning',
      ],
      [
        /_metadata\.drug\.drug_data\..*/
      ]
    )
