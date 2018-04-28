glados.useNameSpace 'glados.configs.ReportCards.Compound',
  TargetSummaryPieConfig: class TargetSummaryPieConfig extends glados.configs.ReportCards.Compound.ToggleAlternateFormsInPieConfig

    constructor: (@compound) ->

    #-------------------------------------------------------------------------------------------------------------------
    # Agg config
    #-------------------------------------------------------------------------------------------------------------------
    @getQueryConfig: ->

      queryConfig =
        type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
        queryValueField: 'molecule_chembl_id'
        fields: ['_metadata.related_compounds.chembl_ids.*']
      return queryConfig

    @getAggConfig: ->

      aggsConfig =
        aggs:
          classes:
            type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
            field: '_metadata.protein_classification.l1'
            size: 20
            bucket_links:

              bucket_filter_template: '_metadata.related_compounds.chembl_ids.\\*:{{molecule_chembl_id}} ' +
                                      'AND _metadata.protein_classification.l1:("{{bucket_key}}"' +
                                      '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
              template_data:
                molecule_chembl_id: 'molecule_chembl_id'
                bucket_key: 'BUCKET.key'
                extra_buckets: 'EXTRA_BUCKETS.key'

              link_generator: Target.getTargetsListURL

      return aggsConfig