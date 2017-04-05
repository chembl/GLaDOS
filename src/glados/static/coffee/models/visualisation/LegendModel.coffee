glados.useNameSpace 'glados.models.visualisation',

  LegendModel: Backbone.Model.extend

    initialize: ->

      defaultDomain = @.get('property').domain
      if defaultDomain?
        @set('domain', defaultDomain)

        # if domain has more than 2 values, I assume that it is discrete
        if defaultDomain.length > 2
          @set('type', glados.models.visualisation.LegendModel.DISCRETE)
          @set('ticks', defaultDomain)

    isDiscrete: -> @get('type') == glados.models.visualisation.LegendModel.DISCRETE

# ----------------------------------------------------------------------------------------------------------------------
# Class Context
# ----------------------------------------------------------------------------------------------------------------------
glados.models.visualisation.LegendModel.CONTINUOUS = 'CONTINUOUS'
glados.models.visualisation.LegendModel.DISCRETE = 'DISCRETE'