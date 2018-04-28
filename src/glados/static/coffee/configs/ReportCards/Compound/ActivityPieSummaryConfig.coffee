glados.useNameSpace 'glados.configs.ReportCards.Compound',
  ActivityPieSummaryConfig: class ActivityPieSummaryConfig extends glados.configs.ReportCards.Compound.ToggleAlternateFormsInPieConfig

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

          titleLinkFilter = Handlebars.compile('molecule_chembl_id:({{#each molecule_chembl_ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
            molecule_chembl_ids: chemblIDs

          relatedActivitiesProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RELATED_ACTIVITIES')
          pieConfig =
            x_axis_prop_name: 'types'
            title: "#{gettext('glados_compound__associated_activities_pie_title_base')}#{chemblID}#{titleAdditionalText}"
            title_link_url: Activity.getActivitiesListURL(titleLinkFilter)
            max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES
            properties:
              types: relatedActivitiesProp
          return pieConfig

      viewConfig =
        init_agg_from_model_event: aggGenerationConfig
        resource_type: gettext('glados_entities_compound_name')
        embed_section_name: 'related_activities'
        embed_identifier: chemblID
        alternate_forms:
          include_alternate_forms: true
        action_button: @getActionButtonConfig()


      return viewConfig

    #-------------------------------------------------------------------------------------------------------------------
    # Agg config
    #-------------------------------------------------------------------------------------------------------------------
    @getQueryConfig: ->

      queryConfig =
        type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
        query_string_template:\
        'molecule_chembl_id:({{#each molecule_chembl_ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})'
        template_data:
          molecule_chembl_ids: 'molecule_chembl_ids'
      return queryConfig

    @getAggConfig: ->

      aggsConfig =
        aggs:
          types:
            type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
            field: 'standard_type'
            size: 20
            bucket_links:

              bucket_filter_template: 'molecule_chembl_id:' +
                '({{#each molecule_chembl_ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}}) ' +
                'AND standard_type:("{{bucket_key}}"' +
                '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
              template_data:
                molecule_chembl_ids: 'molecule_chembl_ids'
                bucket_key: 'BUCKET.key'
                extra_buckets: 'EXTRA_BUCKETS.key'

              link_generator: Activity.getActivitiesListURL
      return aggsConfig