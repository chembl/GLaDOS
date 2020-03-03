glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Mechanism of Action Schema
  # --------------------------------------------------------------------------------------------------------------------
  MechanismSchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      glados.Settings.CHEMBL_ES_INDEX_PREFIX+'mechanism_by_parent_target',
      # Default Selected
      [
        'mechanism_of_action.action_type',
        {
          property:'parent_molecule.molecule_type'
          sort:'asc'
          intervals: 20
        },
        'parent_molecule.max_phase',
        'target._metadata.organism_taxonomy.l1',
        'target._metadata.organism_taxonomy.l2',
        'target._metadata.organism_taxonomy.l3',
        {
          property:'target.organism'
          sort:'asc'
          intervals: 20
        },
        'target._metadata.protein_classification.l1',
        'target._metadata.protein_classification.l2',
        {
          property:'target.target_type'
          sort:'asc'
          intervals: 20
        },
        'parent_molecule.molecule_properties.num_ro5_violations',
        'parent_molecule.molecule_properties.full_mwt',
        'parent_molecule.molecule_properties.alogp',
        'parent_molecule._metadata.drug.is_drug',
        {
          property:'parent_molecule._metadata.atc_classifications.level1_description'
          sort:'asc'
          intervals: 20
        },
        {
          property:'parent_molecule._metadata.atc_classifications.level2_description'
          sort:'asc'
          intervals: 20
        }
      ],
      # Default Hidden
      [
        'target._metadata.protein_classification.l3',
        'target._metadata.protein_classification.l4',
        'parent_molecule.molecule_properties.psa',
        'parent_molecule.molecule_properties.hba',
        'parent_molecule.molecule_properties.hbd',
        'parent_molecule.molecule_properties.rtb',
        'parent_molecule.molecule_properties.qed_weighted',
        'parent_molecule.molecule_properties.cx_logd',
        'parent_molecule.molecule_properties.molecular_species',
        'parent_molecule.molecule_properties.num_lipinski_ro5_violations',
        'parent_molecule.therapeutic_flag',
        'parent_molecule._metadata.compound_generated.availability_type_label',
        'parent_molecule.oral',
        'parent_molecule.parenteral',
        'parent_molecule.topical',
        'parent_molecule.black_box_warning',
        'parent_molecule._metadata.compound_generated.chirality_label',
        'parent_molecule.dosed_ingredient',
        'parent_molecule.first_approval',
        'parent_molecule.first_in_class',
        'parent_molecule.molecule_properties.cx_logp',
        'parent_molecule.molecule_properties.cx_most_apka',
        'parent_molecule.molecule_properties.cx_most_bpka',
        'parent_molecule.molecule_properties.aromatic_rings',
        'parent_molecule.molecule_properties.heavy_atoms',
        'parent_molecule.molecule_properties.mw_freebase',
        'parent_molecule.natural_product',
        'parent_molecule.prodrug',
        'parent_molecule.structure_type',
        {
          property:'parent_molecule.usan_stem'
          sort:'asc'
          intervals: 20
        },
        'parent_molecule.usan_year',
        'parent_molecule.withdrawn_flag',
      ],
      [
        /parent_molecule._metadata\.drug\.drug_data\..*/
      ]
    )
