glados.useNameSpace 'glados.configs.ReportCards.Compound',
  ActivityPieSummaryConfig: class ActivityPieSummaryConfig extends glados.configs.ReportCards.Compound.ToggleAlternateFormsInPieConfig

    constructor: (@compound) ->

    getViewConfig: ->

      chemblID = @compound.get('id')

      aggGenerationConfig =

        model: @compound
        agg_generator_function: (model, thisView) ->

          if thisView.config.alternate_forms.include_alternate_forms
            chemblIDs = model.getOwnAndAdditionalIDs()
          else
            chemblIDs = [model.get('id')]
          return CompoundReportCardApp.getRelatedActivitiesAgg(chemblIDs)

        pie_config_generator_function: (model, thisView) ->
          chemblID = model.get('id')

          if thisView.config.alternate_forms.include_alternate_forms

            chemblIDs = model.getOwnAndAdditionalIDs()
            titleAdditionalText = switch model.isParent()
              when true then ' (including alternate forms)'
              else ' (including parent)'

          else

            chemblIDs = [model.get('id')]
            titleAdditionalText = ''

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
