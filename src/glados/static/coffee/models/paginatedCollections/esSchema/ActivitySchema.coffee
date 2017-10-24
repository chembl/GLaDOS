glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Activity Schema
  # --------------------------------------------------------------------------------------------------------------------
  ActivitySchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_activity',
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
      [
        'assay_type',
        'standard_value',
        'standard_units',
        'document_journal',
        'document_year'
      ],
      [

      ]
    )