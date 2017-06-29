glados.useNameSpace 'glados.models.Target',
  TargetAssociatedCompounds: Backbone.Model.extend

    INITIAL_STATE: 'INITIAL_STATE'
    LOADING_MIN_MAX: 'LOADING_MIN_MAX'
    LOADING_BUCKETS: 'LOADING_BUCKETS'

    initialize: ->

      console.log 'INITIALISING TARGET ASSOCIATED COMPOUNDS!'
      @set('state', @INITIAL_STATE, {silent:true})

    fetch: ->
      console.log 'FETCHING!'
      $progressElem = @get('progress_elem')
      state = @get('state')

      if not @get('min_value')? or not @get('max_value')? or state == @INITIAL_STATE
        if $progressElem?
          $progressElem.html 'Loading minimun and maximum values...'
        @set('state', @LOADING_MIN_MAX, {silent:true})
        console.log 'GOING TO FETCH MIN MAX'
        @fetchMinMax()
        return



      @set(@parse())

    fetchMinMax: ->

      console.log 'FETCHING MIN MAX'
      esJSONRequest = JSON.stringify(@getRequestMinMaxData())

      fetchESOptions =
        url: @url
        data: esJSONRequest
        type: 'POST'
        reset: true

      thisModel = @
      $.ajax(fetchESOptions).done((data) ->
        thisModel.set(thisModel.parseMinMax data, {silent:true})
      ).fail( (jqXHR, textStatus, errorThrown) ->
        $progressElem = thisModel.get('progress_elem')
        $progressElem.html 'Error loading data'
        console.log 'ERROR:'
        console.log 'jqXHR: ', jqXHR
        console.log 'textStatus: ', textStatus
        console.log 'errorThrown: ', errorThrown
      )


    parse: (data) ->

      buckets = [
        {"key":"0","doc_count":94,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Ratio\""},
        {"key":"50","doc_count":32,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Ki\""},
        {"key":"100","doc_count":18,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"IC50\""},
        {"key":"150","doc_count":5,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"EC50\""},
        {"key":"200","doc_count":5,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Emax\""},
        {"key":"250","doc_count":4,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Change\""},
        {"key":"300","doc_count":2,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Bmax\""},
        {"key":"350","doc_count":2,"link":"/activities/filter/target_chembl_id:CHEMBL2111342 AND standard_type:\"Kd\""}
      ]

      return {
        'buckets': buckets
      }

    getRequestData: ->

      return {

      }

    getRequestMinMaxData: ->

      return {
        size: 0,
        query: {
          query_string: {
            analyze_wildcard: true,
            query: "*"
          }
        },
        aggs: {
          min_agg: {
            min: {
              field: @get('current_xaxis_property')
            }
          },
          max_agg: {
            max: {
              field: @get('current_xaxis_property')
            }
          }
        }
      }

    parseMinMax: (data) ->

      parsedObj = {
        max_value: data.aggregations.max_agg.value
        min_value: data.aggregations.min_agg.value
      }
      state = @get('state')
      console.log 'PARSED MIN AND MAX'
      if state == @LOADING_MIN_MAX
        @set('state', @LOADING_BUCKETS, {silent:true})
        console.log 'GOT MIN AND MAX'
        @fetch()

      return parsedObj
