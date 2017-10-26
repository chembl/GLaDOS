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
        'bao_format',
        'pchembl_value',
        # TODO missing max_phase
        # TODO missing RO5 violations
        # TODO missing alogp
        # TODO missing molecular weight
        'src_id'
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