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
        @config.alternate_forms.include_alternate_forms = not @config.alternate_forms.include_alternate_forms
        @initAggAndBindFromGenModel()