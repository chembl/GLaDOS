glados.useNameSpace 'glados.configs.ReportCards.Compound',
  TargetSummaryPieConfig: class TargetSummaryPieConfig extends glados.configs.ReportCards.Compound.ToggleAlternateFormsInPieConfig

    constructor: (@compound) ->

    getViewConfig: ->

      chemblID = @compound.get('id')

      aggGenerationConfig =

        model: @compound
        agg_generator_function: @aggGeneratorFunction

        pie_config_generator_function: (model, thisView) ->
          chemblID = model.get('id')

          [chemblIDs, titleAdditionalText] = glados.configs.ReportCards.Compound.ToggleAlternateFormsInPieConfig\
            .getChemblIDsAndTitleAdditionalText(model, thisView)

          titleLinkFilter = Handlebars.compile('_metadata.related_compounds.all_chembl_ids:({{#each molecule_chembl_ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
            molecule_chembl_ids: chemblIDs

          relatedTargetsProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RELATED_TARGETS')

          pieConfig =
            x_axis_prop_name: 'classes'
            title: "#{'Target Classes for Compound '}#{chemblID}#{titleAdditionalText}"
            title_link_url: Target.getTargetsListURL(titleLinkFilter)
            custom_empty_message: "No target classification data available for compound #{chemblID} (all may be non-protein targets)"
            max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES
            properties:
              classes: relatedTargetsProp
          return pieConfig

      viewConfig =
        init_agg_from_model_event: aggGenerationConfig
        resource_type: Compound.prototype.entityName
        embed_section_name: 'related_targets'
        embed_identifier: chemblID
        alternate_forms:
          include_alternate_forms: true
        action_button: @getActionButtonConfig()

      return viewConfig

    aggGeneratorFunction: (model, thisView) ->

      if thisView.config.alternate_forms.include_alternate_forms
        chemblIDs = model.getOwnAndAdditionalIDs()
      else
        chemblIDs = [model.get('id')]
      return CompoundReportCardApp.getRelatedTargetsAggByClass(chemblIDs)
    #-------------------------------------------------------------------------------------------------------------------
    # Agg config
    #-------------------------------------------------------------------------------------------------------------------
    @getQueryConfig: ->

      queryConfig =
        type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
        query_string_template:\
        '_metadata.related_compounds.all_chembl_ids:({{#each molecule_chembl_ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})'
        template_data:
          molecule_chembl_ids: 'molecule_chembl_ids'
      return queryConfig

    @getAggConfig: ->

      aggsConfig =
        aggs:
          classes:
            type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
            field: '_metadata.protein_classification.l1'
            size: 20
            bucket_links:

              bucket_filter_template: '_metadata.related_compounds.all_chembl_ids:' +
                                      '({{#each molecule_chembl_ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}}) ' +
                                      'AND _metadata.protein_classification.l1:("{{bucket_key}}"' +
                                      '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
              template_data:
                molecule_chembl_ids: 'molecule_chembl_ids'
                bucket_key: 'BUCKET.key'
                extra_buckets: 'EXTRA_BUCKETS.key'

              link_generator: Target.getTargetsListURL

      return aggsConfig