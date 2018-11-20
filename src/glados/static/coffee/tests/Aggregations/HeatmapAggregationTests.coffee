describe 'Heatmap Aggregation', ->

  compoundIds = ['CHEMBL59, CHEMBL25', 'CHEMBL10']
  noSearchIndexes = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH
  indexName = noSearchIndexes.ACTIVITY.INDEX_NAME

  generateQuery = (itemsIDS) ->

    filteredTermsQuery = {
      "bool": {
        "filter":{
          "terms": {
            "molecule_chembl_id": itemsIDS
          }
        }
      }
    }

    esQuery = {
      "bool": {
        "should": filteredTermsQuery
      }
    }
    return esQuery


  queryConfig =
    type: glados.models.Aggregations.Aggregation.QueryTypes.CUSTOM
    query: generateQuery(compoundIds)

  aggsConfig =
    aggs:
      children:
        type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
        field: '_metadata.protein_classification.l1'
        size: 100
        bucket_links:
          bucket_filter_template: '_metadata.protein_classification.l1:("{{bucket_key}}")'
          template_data:
            bucket_key: 'BUCKET.key'
          link_generator: Target.getTargetsListURL
        aggs:
          children:
            type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
            field: '_metadata.protein_classification.l2'
            size: 100
            bucket_links:
              bucket_filter_template: '_metadata.protein_classification.l2:("{{bucket_key}}")'
              template_data:
                bucket_key: 'BUCKET.key'
              link_generator: Target.getTargetsListURL

  heatmapAggregation = new glados.models.Aggregations.HeatmapAggregation
    index_name: indexName
    query_config: queryConfig
    aggs_config: aggsConfig

  it 'initialises correctly', ->

    console.log 'queryConfig: ', queryConfig
    console.log 'aggsConfig: ', aggsConfig
    console.log 'heatmapAggregation: ', heatmapAggregation

    expect(heatmapAggregation.get('state'))\
      .toBe(glados.models.Aggregations.HeatmapAggregation.States.INITIAL_STATE)

    queryGot = heatmapAggregation.get('query')
    expect(queryGot?).toBe(true)
    iDsGot = queryGot.bool.should.bool.filter.terms.molecule_chembl_id
    expect(_.isEqual(iDsGot, compoundIds)).toBe(true)



