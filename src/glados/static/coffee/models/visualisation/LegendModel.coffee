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
          @set('colour-range', @.get('property').coloursRange)

    isDiscrete: -> @get('type') == glados.models.visualisation.LegendModel.DISCRETE

    selectByPropertyValue: (value) -> @get('collection').selectByPropertyValue(@.get('property').propName, value)

# ----------------------------------------------------------------------------------------------------------------------
# Class Context
# ----------------------------------------------------------------------------------------------------------------------
glados.models.visualisation.LegendModel.CONTINUOUS = 'CONTINUOUS'
glados.models.visualisation.LegendModel.DISCRETE = 'DISCRETE'