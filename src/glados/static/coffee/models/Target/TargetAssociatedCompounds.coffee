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
        console.log 'GOING TO FETCH MIN MAX'
        @fetchMinMax()
        return

      if $progressElem?
        $progressElem.html 'Fetching Compound Data...'

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

      buckets = data.aggregations.x_axis_agg.buckets
      return {
        'buckets': buckets
      }

    getRequestData: ->

      xaxisProperty = @get('current_xaxis_property')
      interval = Math.ceil((@get('max_value') - @get('min_value')) / @get('num_columns')) + @get('min_value')

      return {
        size: 0,
        query:
          query_string:
            "analyze_wildcard": true,
            "query": "*"
        aggs:
          x_axis_agg:
            histogram:
              field: xaxisProperty,
              interval: interval,
              min_doc_count: 1
      }

    getRequestMinMaxData: ->

      return {
        size: 0,
        query:
          query_string:
            analyze_wildcard: true,
            query: "*"
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
