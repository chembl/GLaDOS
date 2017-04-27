glados.useNameSpace 'glados.models.visualisation',

  LegendModel: Backbone.Model.extend

    initialize: ->

      @get('collection').on(glados.Events.Collections.SELECTION_UPDATED, @handleCollSelectionChanged, @)
      @set('domain', @get('property').domain)

      if @isDiscrete()
        @set('type', glados.models.visualisation.LegendModel.DISCRETE)
        @set('ticks', @get('property').domain)
        @set('colour-range', @get('property').coloursRange)
        @set('values-selection', {})
        @fillAmountPerValue()

    isDiscrete: -> @get('property').colourScaleType == glados.Visualisation.CATEGORICAL

    # ------------------------------------------------------------------------------------------------------------------
    # Categorical
    # ------------------------------------------------------------------------------------------------------------------
    selectByPropertyValue: (value) ->

      @get('collection').selectByPropertyValue(@get('property').propName, value)
      @get('values-selection')[value] = true
      @trigger(glados.Events.Legend.VALUE_SELECTED, value)

    unselectByPropertyValue: (value) ->

      @get('collection').unselectByPropertyValue(@get('property').propName, value)
      @get('values-selection')[value] = false
      @trigger(glados.Events.Legend.VALUE_UNSELECTED, value)

    toggleValueSelection: (value) ->

      if @isValueSelected(value)
        @unselectByPropertyValue(value)
      else
        @selectByPropertyValue(value)

    isValueSelected: (value) ->
      if not @get('values-selection')[value]?
        return false
      return @get('values-selection')[value]

    selectAllValues: ->

      valuesSelection =  @get('values-selection')
      domain = @get('domain')
      for value in domain
        valuesSelection[value] = true
        @trigger(glados.Events.Legend.VALUE_SELECTED, value)

    unSelectAllValues: ->
      
      valuesSelection =  @get('values-selection')
      domain = @get('domain')
      for value in domain
        valuesSelection[value] = false
        @trigger(glados.Events.Legend.VALUE_UNSELECTED, value)

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

    # ------------------------------------------------------------------------------------------------------------------
    # Handle Selections in collection
    # ------------------------------------------------------------------------------------------------------------------
    handleCollSelectionChanged: (param) ->
      if param == glados.Events.Collections.Params.ALL_UNSELECTED
        @unSelectAllValues()
      else if param == glados.Events.Collections.Params.ALL_SELECTED
        @selectAllValues()