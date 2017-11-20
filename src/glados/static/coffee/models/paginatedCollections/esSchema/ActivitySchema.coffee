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
        # TODO missing target_type
        'target_organism',
        'bao_label',
        'pchembl_value',
        '_metadata.parent_molecule_data.max_phase'
        '_metadata.parent_molecule_data.num_ro5_violations'
        '_metadata.parent_molecule_data.alogp'
        '_metadata.parent_molecule_data.full_mwt'
        '_metadata.source.src_description'
      ],
      # Default Hidden
      [
        'standard_value',
        'standard_units',
        'standard_relation',
        'assay_chembl_id',
        'assay_type',
        'document_chembl_id',
        'document_journal',
        'document_year',
        'ligand_efficiency.bei',
        'ligand_efficiency.le',
        'ligand_efficiency.lle',
        'ligand_efficiency.sei',
        'molecule_chembl_id',
        'potential_duplicate',
        'target_chembl_id',
        'target_tax_id',
      ],
      [

      ]
    )