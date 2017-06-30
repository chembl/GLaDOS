glados.useNameSpace 'glados.models.Target',
  TargetAssociatedCompounds: Backbone.Model.extend

    INITIAL_STATE: 'INITIAL_STATE'
    LOADING_MIN_MAX: 'LOADING_MIN_MAX'
    LOADING_BUCKETS: 'LOADING_BUCKETS'

    initialize: ->

      @url = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_molecule/_search'
      @set('state', @INITIAL_STATE, {silent:true})

    fetch: ->

      $progressElem = @get('progress_elem')
      state = @get('state')

      if state == @INITIAL_STATE
        if $progressElem?
          $progressElem.html 'Loading minimun and maximum values...'
        @set('state', @LOADING_MIN_MAX, {silent:true})
        @fetchMinMax()
        return

      if $progressElem?
        $progressElem.html 'Fetching Compound Data...'

      console.log 'request data: ', @getRequestData()
      esJSONRequest = JSON.stringify(@getRequestData())

      fetchESOptions =
        url: @url
        data: esJSONRequest
        type: 'POST'
        reset: true

      thisModel = @
      $.ajax(fetchESOptions).done((data) ->
        if $progressElem?
          $progressElem.html ''

        thisModel.set(thisModel.parse(data))
        thisModel.set('state', thisModel.INITIAL_STATE, {silent:true})

      ).fail( glados.Utils.ErrorMessages.showLoadingErrorMessageGen($progressElem))

      return
      @set(@parse())

    fetchMinMax: ->

      $progressElem = @get('progress_elem')
      esJSONRequest = JSON.stringify(@getRequestMinMaxData())

      fetchESOptions =
        url: @url
        data: esJSONRequest
        type: 'POST'
        reset: true

      thisModel = @
      $.ajax(fetchESOptions).done((data) ->
        thisModel.set(thisModel.parseMinMax(data), {silent:true})
        thisModel.set('state', thisModel.LOADING_BUCKETS, {silent:true})
        thisModel.fetch()
      ).fail( glados.Utils.ErrorMessages.showLoadingErrorMessageGen($progressElem))


    parse: (data) ->

      buckets = []
      for key, bucket of data.aggregations.x_axis_agg.buckets
        bucket.key = key
        buckets.push bucket

      return {
        'buckets': buckets
      }

    getRequestData: ->

      xaxisProperty = @get('current_xaxis_property')
      minValue = @get('min_value')
      maxValue = @get('max_value')
      numCols = @get('num_columns')

      # probably the number of digits will have to be set depending on the property
      interval = parseFloat((Math.ceil(Math.abs(maxValue - minValue)) / numCols).toFixed(2))

      ranges = []
      from = minValue
      to = minValue + interval
      for col in [0..numCols-1]
        from = parseFloat(from.toFixed(2))
        to = parseFloat(to.toFixed(2))
        ranges.push
          from: from
          to: to

        from += interval
        to += interval

      return {
        size: 0
        query:
          multi_match:
            query: @get('target_chembl_id')
            fields: ["_metadata.related_targets.chembl_ids.*"]
        aggs:
          x_axis_agg:
            range:
              field: xaxisProperty
              ranges: ranges
              keyed: true
      }

    getRequestMinMaxData: ->

      return {
        size: 0,
        query:
          multi_match:
            query: @get('target_chembl_id')
            fields: ["_metadata.related_targets.chembl_ids.*"]
        aggs:
          min_agg:
            min:
              field: @get('current_xaxis_property')
          max_agg:
            max:
              field: @get('current_xaxis_property')
      }

    parseMinMax: (data) ->
      return {
        max_value: data.aggregations.max_agg.value
        min_value: data.aggregations.min_agg.value
      }
