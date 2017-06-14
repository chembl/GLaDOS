TargetAssociatedBioactivities = Backbone.Model.extend

  initialize: ->
    @url = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_activity/_search'

  fetch: ->
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
    for bucket in buckets
      labelFilter = 'standard_type:"' + bucket.key + '"'
      filter = 'target_chembl_id:' + @get('target_chembl_id') + ' AND ' + labelFilter
      bucket.link = Activity.getActivitiesListURL(filter)
    return  {
      'pie-data': buckets
      'title': 'ChEMBL Activity types for target ' + @get('target_chembl_id')
      'buckets_index': _.indexBy(buckets, 'key')
      'link_to_all': Activity.getActivitiesListURL('target_chembl_id:' + @get('target_chembl_id'))
    }

  getRequestData: ->

    return {
      query:
        query_string:
          analyze_wildcard: true
          query: 'target_chembl_id=' + @get('target_chembl_id')
      size: 0
      aggs:
        types:
          terms:
            field: 'standard_type'
            size: 20
            order:
              _count: 'desc'

    }