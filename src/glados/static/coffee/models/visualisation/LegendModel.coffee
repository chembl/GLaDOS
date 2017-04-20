glados.useNameSpace 'glados.models.visualisation',

  LegendModel: Backbone.Model.extend

    initialize: ->

      defaultDomain = @get('property').domain
      if defaultDomain?
        @set('domain', defaultDomain)

        # if domain has more than 2 values, I assume that it is discrete
        if defaultDomain.length > 2
          @set('type', glados.models.visualisation.LegendModel.DISCRETE)
          @set('ticks', defaultDomain)
          @set('colour-range', @get('property').coloursRange)

      if @isDiscrete()
        @set('selected-values', [])

    isDiscrete: -> @get('type') == glados.models.visualisation.LegendModel.DISCRETE

    selectByPropertyValue: (value) ->

      @get('collection').selectByPropertyValue(@get('property').propName, value)
      @get('selected-values').push(value)
      @trigger(glados.Events.Legend.VALUE_SELECTED, value)
      

    isValueSelected: (value) -> _.contains(@get('selected-values'), value)

# ----------------------------------------------------------------------------------------------------------------------
# Class Context
# ----------------------------------------------------------------------------------------------------------------------
glados.models.visualisation.LegendModel.CONTINUOUS = 'CONTINUOUS'
glados.models.visualisation.LegendModel.DISCRETE = 'DISCRETE'