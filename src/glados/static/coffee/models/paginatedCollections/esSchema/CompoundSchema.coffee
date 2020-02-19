glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Compound Schema
  # --------------------------------------------------------------------------------------------------------------------
  CompoundSchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      glados.Settings.CHEMBL_ES_INDEX_PREFIX+'molecule',
      # Default Selected
      [
        {
          property:'molecule_type'
          sort:'asc'
          intervals: 20
        },
        'max_phase',
        'molecule_properties.num_ro5_violations',
        'molecule_properties.full_mwt',
        'molecule_properties.alogp',
        {
          property:'_metadata.atc_classifications.level1_description'
          sort:'asc'
          intervals: 20
        },
        {
          property:'_metadata.atc_classifications.level2_description'
          sort:'asc'
          intervals: 20
        },
        '_metadata.related_targets.count',
        '_metadata.related_activities.count',
      ],
      # Default Hidden
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
        '_metadata.compound_generated.availability_type_label',
        'oral',
        'parenteral',
        'topical',
        'black_box_warning',
        '_metadata.compound_generated.chirality_label',
        'dosed_ingredient',
        'first_approval',
        'first_in_class',
        'molecule_properties.acd_logp',
        'molecule_properties.acd_most_apka',
        'molecule_properties.acd_most_bpka',
        'molecule_properties.aromatic_rings',
        'molecule_properties.heavy_atoms',
        'molecule_properties.mw_freebase',
        'natural_product',
        'prodrug',
        'structure_type',
        {
          property:'usan_stem'
          sort:'asc'
          intervals: 20
        },
        'usan_year',
        'withdrawn_flag',
        'withdrawn_class',
        'withdrawn_year',
        'withdrawn_reason',
        'withdrawn_country'
      ],
      [
        /_metadata\.drug\.drug_data\..*/
      ]
    )
