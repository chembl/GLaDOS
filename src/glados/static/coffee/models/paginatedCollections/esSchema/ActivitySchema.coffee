glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Activity Schema
  # --------------------------------------------------------------------------------------------------------------------
  ActivitySchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_activity',
      # Default Selected
      [
        'standard_type',
        {
          property:'_metadata.target_data.target_type'
          sort:'asc'
          intervals: 20
        },
        '_metadata.organism_taxonomy.l1',
        '_metadata.organism_taxonomy.l2',
        '_metadata.organism_taxonomy.l3',
        {
          property:'target_organism'
          sort:'asc'
          intervals: 20
        },
        {
          property:'bao_label'
          sort:'asc'
          intervals: 20
        },
        'pchembl_value',
        '_metadata.parent_molecule_data.max_phase',
        '_metadata.parent_molecule_data.num_ro5_violations',
        '_metadata.parent_molecule_data.alogp',
        '_metadata.parent_molecule_data.full_mwt',
        {
          property:'_metadata.source.src_description'
          sort:'asc'
          intervals: 20
        },
      ],
      # Default Hidden
      [
        {
          property:'molecule_chembl_id'
          intervals: 20
          report_card_model: Compound
        },
        {
          property:'target_chembl_id'
          intervals: 20
          report_card_model: Target
        },
        {
          property:'assay_chembl_id'
          intervals: 20
          report_card_model: Assay
        },
        {
          property:'document_chembl_id'
          intervals: 20
          report_card_model: Document
        },
        'standard_value',
        'standard_units',
        'standard_relation',
        '_metadata.assay_data.type_label',
        'document_journal',
        'document_year',
        'ligand_efficiency.bei',
        'ligand_efficiency.le',
        'ligand_efficiency.lle',
        'ligand_efficiency.sei',
        'molecule_chembl_id',
        'potential_duplicate',
        '_metadata.activity_generated.short_data_validity_comment',
        '_metadata.protein_classification.l1'
      ],
      [

      ]
    )