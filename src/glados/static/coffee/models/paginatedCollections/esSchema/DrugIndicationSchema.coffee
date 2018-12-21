glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Drug Indication Schema
  # --------------------------------------------------------------------------------------------------------------------
  DrugIndicationSchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_drug_indication_by_parent',
      # Default Selected
      [
        {
          property:'drug_indication.mesh_heading'
          sort:'asc'
          intervals: 20
        },
        {
          property:'drug_indication.efo.term'
          sort:'asc'
          intervals: 20
        },
        'drug_indication.max_phase_for_ind',
        {
          property:'parent_molecule.molecule_type'
          sort:'asc'
          intervals: 20
        },
        'parent_molecule.molecule_properties.num_ro5_violations',
        'parent_molecule.molecule_properties.full_mwt',
        'parent_molecule.molecule_properties.alogp',
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
        'parent_molecule.molecule_properties.psa',
        'parent_molecule.molecule_properties.hba',
        'parent_molecule.molecule_properties.hbd',
        'parent_molecule.molecule_properties.rtb',
        'parent_molecule.molecule_properties.qed_weighted',
        'parent_molecule.molecule_properties.acd_logd',
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
        'parent_molecule.molecule_properties.acd_logp',
        'parent_molecule.molecule_properties.acd_most_apka',
        'parent_molecule.molecule_properties.acd_most_bpka',
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
      ]
    )
