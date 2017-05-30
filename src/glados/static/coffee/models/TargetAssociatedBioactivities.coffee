TargetAssociatedBioactivities = Backbone.Model.extend

  initialize: ->
    @url = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_activity/_search'
    console.log 'init model: ', @url

  fetch: ->
    console.log 'going to fetch ', @url
    console.log 'for: ', @get('target_chembl_id')
    esJSONRequest = JSON.stringify(@getRequestData())

    fetchESOptions =
      url: @url
      data: esJSONRequest
      type: 'POST'
      reset: true

    thisModel = @
    $.ajax(fetchESOptions).done((data) -> thisModel.set(thisModel.parse data))


  parse: (data) ->

    buckets = data.aggregations.types.buckets
    return  {"pie-data": buckets}

  getRequestData: ->

    return {
      query:
        'query_string':
          'analyze_wildcard': true
          'query': 'target_chembl_id=' + @get('target_chembl_id')
      'size': 0
      'aggs':
        'types':
          'terms':
            'field': 'standard_type'
            'size': 20
            'order':
              '_count': 'desc'

    }