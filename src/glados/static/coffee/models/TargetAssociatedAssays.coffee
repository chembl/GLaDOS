TargetAssociatedAssays = Backbone.Model.extend

  initialize: ->
    @url = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_assay/_search'
    console.log 'init target associated assays: ', @url

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

    buckets = data.aggregations.descriptions.buckets
    for bucket in buckets
      letter = bucket.description_letter.buckets[0].key
      labelFilter = 'assay_type=' + letter
      filter = 'target_chembl_id=' + @get('target_chembl_id') + '&' + labelFilter
      bucket.link = Assay.getAssaysListURL(filter)

    console.log 'buckets for assays: ', buckets
    title = 'ChEMBL Assays for Target ' + @get('target_chembl_id')
    console.log '^^^'
    return  {
      'pie-data': buckets
      'title': title
      'buckets_index': _.indexBy(buckets, 'key')
    }

  getRequestData: ->

    return {
      query:
        query_string:
          analyze_wildcard: true
          query: 'target_chembl_id=' + @get('target_chembl_id')
      size: 0
      aggs:
        descriptions:
          terms:
            field: 'assay_type_description'
            size: 20
            order:
              _count: 'desc'
          aggs:
            description_letter:
              terms:
                field: 'assay_type'
                size: 5
                order:
                  _count: 'desc'

    }