glados.useNameSpace 'glados.models.visualisation',

  LegendModel: Backbone.Model.extend

    initialize: ->

      if @get('collection')?
        @get('collection').on(glados.Events.Collections.SELECTION_UPDATED, @handleCollSelectionChanged, @)

      @set('selection-enabled', @get('collection')?)

      @set('domain', @get('property').domain)
      @set('colour-range', @get('property').coloursRange)

      if @isDiscrete()
        @set('ticks', @get('property').domain)
        @set('values-selection', {}) unless not @get('selection-enabled')
        @fillAmountPerValue()
      else
       # only used  for undefined value
        @set('values-selection', {}) unless not @get('selection-enabled')
        @setTicks()

    isDiscrete: -> @get('property').colourScaleType == glados.Visualisation.CATEGORICAL
    # ------------------------------------------------------------------------------------------------------------------
    # Continuous
    # ------------------------------------------------------------------------------------------------------------------
    setTicks: ->
      numTicks = @get('property').ticksNumber
      start = @get('domain')[0]
      stop = @get('domain')[1]
      step = Math.abs(stop - start) / (numTicks - 1)
      ticks = d3.range(start, stop, step)
      ticks.push(stop)
      @set('ticks', ticks)

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

      return unless @get('selection-enabled')

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
    # Categorical
    # ------------------------------------------------------------------------------------------------------------------
    selectRange: (minValue, maxValue) ->
      @set('values-selection-min', minValue)
      @set('values-selection-max', maxValue)
      @get('collection').selectByPropertyRange(@get('property').propName, minValue, maxValue)
      @trigger(glados.Events.Legend.RANGE_SELECTED)

    selectFullRange: ->
      @set('values-selection-min', @get('domain')[0])
      @set('values-selection-max', @get('domain')[1])
      @trigger(glados.Events.Legend.RANGE_SELECTED)

    # ------------------------------------------------------------------------------------------------------------------
    # Handle Selections in collection
    # ------------------------------------------------------------------------------------------------------------------
    handleCollSelectionChanged: (param) ->
      if param == glados.Events.Collections.Params.ALL_UNSELECTED
        if @isDiscrete()
          @unSelectAllValues()
        else
          @trigger(glados.Events.RANGE_SELECTION_INVALID)
      else if param == glados.Events.Collections.Params.ALL_SELECTED
        if @isDiscrete()
          @selectAllValues()
        else
          @selectFullRange()