describe 'Heatmap Aggregation', ->

  compoundIds = ['CHEMBL59', 'CHEMBL25', 'CHEMBL10']
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
      y_axis:
        type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
        field: 'molecule_chembl_id'
        size: 10000000
        aggs:
          x_axis:
            type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
            field: 'target_chembl_id'
            size: 10000000
            aggs:
              max_pchembl_value:
                type: glados.models.Aggregations.Aggregation.AggTypes.MAX
                field: 'pchembl_value'
              avg_pchembl_value:
                type: glados.models.Aggregations.Aggregation.AggTypes.AVG
                field: 'pchembl_value'
          max_pchembl_value:
            type: glados.models.Aggregations.Aggregation.AggTypes.MAX
            field: 'pchembl_value'

  colsFootersCountsConfig =
    index_name: 'chembl_target'
    doc_count: 'activity_count'
    from_x_agg: [
      {
        prop_name:'max_pchembl_value'
        type: glados.models.Aggregations.Aggregation.AggTypes.MAX
      }
    ]

  rowsFootersCountsConfig =
    index_name: 'chembl_molecule'
    from_y_agg: [
      {
        prop_name:'max_pchembl_value'
        type: glados.models.Aggregations.Aggregation.AggTypes.MAX
      }
    ]

  cellsDataConfig =
    from_x_agg: [
      {
        prop_name:'avg_pchembl_value'
        type: glados.models.Aggregations.Aggregation.AggTypes.AVG
      }
    ]

#          children:
#            type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
#            field: '_metadata.protein_classification.l2'
#            size: 100
#            bucket_links:
#              bucket_filter_template: '_metadata.protein_classification.l2:("{{bucket_key}}")'
#              template_data:
#                bucket_key: 'BUCKET.key'
#              link_generator: Target.getTargetsListURL

  heatmapAggregation = new glados.models.Aggregations.HeatmapAggregation
    index_name: indexName
    query_config: queryConfig
    aggs_config: aggsConfig
    cols_footers_counts_config: colsFootersCountsConfig
    rows_footers_counts_config: rowsFootersCountsConfig
    cells_data_config: cellsDataConfig

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

  it 'generates the request data', ->

    requestDataGot = heatmapAggregation.getRequestData()
    fieldGot = requestDataGot.aggs.y_axis.terms.field
    expect(fieldGot).toBe(aggsConfig.aggs.y_axis.field)

  it 'parses the min and max values of cells', ->

    heatmapAggregation.requestInitInServer()


