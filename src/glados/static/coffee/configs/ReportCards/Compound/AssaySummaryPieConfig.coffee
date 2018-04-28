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

          [chemblIDs, titleAdditionalText] = glados.configs.ReportCards.Compound.ToggleAlternateFormsInPieConfig\
          .getChemblIDsAndTitleAdditionalText(model, thisView)

          titleLinkFilter = Handlebars.compile('_metadata.related_compounds.chembl_ids.\\*:({{#each molecule_chembl_ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
            molecule_chembl_ids: chemblIDs

          relatedAssaysProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RELATED_ASSAYS')

          pieConfig =
            x_axis_prop_name: 'types'
            title: gettext('glados_compound__associated_assays_pie_title_base') + chemblID
            title_link_url: Assay.getAssaysListURL(titleLinkFilter)
            max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES
            properties:
              types: relatedAssaysProp
          return pieConfig

      viewConfig =
        init_agg_from_model_event: aggGenerationConfig
        resource_type: gettext('glados_entities_compound_name')
        embed_section_name: 'related_assays'
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
      return CompoundReportCardApp.getRelatedAssaysAgg(chemblIDs)

    #-------------------------------------------------------------------------------------------------------------------
    # Agg config
    #-------------------------------------------------------------------------------------------------------------------
    @getQueryConfig: ->

      queryConfig =
        type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
        query_string_template:\
        '_metadata.related_compounds.chembl_ids.\\*:({{#each molecule_chembl_ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})'
        template_data:
          molecule_chembl_ids: 'molecule_chembl_ids'
      return queryConfig

    @getAggConfig: ->

      aggsConfig =
        aggs:
          types:
            type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
            field: '_metadata.assay_generated.type_label'
            size: 20
            bucket_links:

              bucket_filter_template: '_metadata.related_compounds.chembl_ids.\\*:' +
                                      '({{#each molecule_chembl_ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}}) ' +
                                      'AND _metadata.assay_generated.type_label:("{{bucket_key}}"' +
                                      '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
              template_data:
                molecule_chembl_ids: 'molecule_chembl_ids'
                bucket_key: 'BUCKET.key'
                extra_buckets: 'EXTRA_BUCKETS.key'

              link_generator: Assay.getAssaysListURL
      return aggsConfig