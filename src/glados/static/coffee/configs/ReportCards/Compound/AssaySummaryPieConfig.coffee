glados.useNameSpace 'glados.configs.ReportCards.Compound',
  AssaySummaryPieConfig: class AssaySummaryPieConfig extends glados.configs.ReportCards.Compound.ToggleAlternateFormsInPieConfig

    constructor: (@compound) ->

    getViewConfig: ->

      chemblID = @compound.get('id')

      aggGenerationConfig =

        model: @compound
        agg_generator_function: @aggGeneratorFunction

        pie_config_generator_function: (model, thisView) ->
          chemblID = model.get('id')

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
          types:
            type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
            field: '_metadata.assay_generated.type_label'
            size: 20
            bucket_links:

              bucket_filter_template: '_metadata.related_compounds.chembl_ids.\\*:{{molecule_chembl_id}} ' +
                                      'AND _metadata.assay_generated.type_label:("{{bucket_key}}"' +
                                      '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
              template_data:
                molecule_chembl_id: 'molecule_chembl_id'
                bucket_key: 'BUCKET.key'
                extra_buckets: 'EXTRA_BUCKETS.key'

              link_generator: Assay.getAssaysListURL
      return aggsConfig