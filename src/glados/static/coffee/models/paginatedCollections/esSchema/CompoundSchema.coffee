glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Compound Schema
  # --------------------------------------------------------------------------------------------------------------------
  CompoundSchema:
    facets:
      [
        {
          aggs_query:
            molecular_weight:
              histogram:
                field: 'molecular_weight'
                interval: ''
        }
      ]