glados.useNameSpace 'glados.configs.ReportCards.Compound',
  ToggleAlternateFormsInPieConfig: class ToggleAlternateFormsInPieConfig

    getActionButtonConfig: ->
      text_function: (thisView) ->
        config = thisView.config
        includeExclude = switch config.alternate_forms.include_alternate_forms
          when true then 'Exclude '
          else 'Include '
        return "#{includeExclude} Alternate Forms Data"
      action_function: (event) ->

        @showCardPreloader()
        includeAlternateForms = not @config.alternate_forms.include_alternate_forms
        @config.alternate_forms.include_alternate_forms = includeAlternateForms

        generatorModel = @config.init_agg_from_model_event.model

        if includeAlternateForms
          chemblIDs = generatorModel.getOwnAndAdditionalIDs()
        else
          chemblIDs = [generatorModel.get('id')]

        @model.set
          molecule_chembl_ids: chemblIDs
        ,
          silent: true

        pieViewConfig = @pieView.config
        pieConfigGeneratorFunction = @config.init_agg_from_model_event.pie_config_generator_function
        newPieViewConfig = pieConfigGeneratorFunction(generatorModel, @)

        # for now, the only thing that changes is the title
        pieViewConfig = newPieViewConfig

        @model.fetch()