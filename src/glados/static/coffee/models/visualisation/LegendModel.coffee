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
        @fillAmountPerValue()

    isDiscrete: -> @get('type') == glados.models.visualisation.LegendModel.DISCRETE

    # ----------------------------------------------------------------------------------------------------------------------
    # Categorical
    # ----------------------------------------------------------------------------------------------------------------------
    selectByPropertyValue: (value) ->

      @get('collection').selectByPropertyValue(@get('property').propName, value)
      @get('selected-values').push(value)
      @trigger(glados.Events.Legend.VALUE_SELECTED, value)


    isValueSelected: (value) -> _.contains(@get('selected-values'), value)

    fillAmountPerValue: ->
      collection = @get('collection')
      if collection.allResults?
        allItemsObjs = collection.allResults
      else
        allItemsObjs = (model.attributes for model in collection.models)

      amountsPerValue = {}
      prop = @get('property')
      for obj in allItemsObjs
        value = glados.Utils.getNestedValue(obj, prop.propName)
        if not amountsPerValue[value]?
          amountsPerValue[value] = 0
        amountsPerValue[value]++

      @set('amounts-per-value', amountsPerValue)

    getTextAmountPerValue: (value) ->
      ans = @get('amounts-per-value')[value]
      if not ans?
        return 0
      return ans


# ----------------------------------------------------------------------------------------------------------------------
# Class Context
# ----------------------------------------------------------------------------------------------------------------------
glados.models.visualisation.LegendModel.CONTINUOUS = 'CONTINUOUS'
glados.models.visualisation.LegendModel.DISCRETE = 'DISCRETE'