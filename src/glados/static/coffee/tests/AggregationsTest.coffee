describe 'Aggregation', ->

  describe 'with a numeric property (Associated compounds for a target)', ->

    associatedCompounds = undefined
    minMaxTestData = undefined
    indexUrl = glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
    currentXAxisProperty = 'molecule_properties.full_mwt'
    targetChemblID = 'CHEMBL2111342'

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'target_chembl_id'
      fields: ['_metadata.related_targets.chembl_ids.*']

    aggsConfig =
      aggs:
        x_axis_agg:
          field: 'molecule_properties.full_mwt'
          type: glados.models.Aggregations.Aggregation.AggTypes.RANGE
          min_columns: 1
          max_columns: 20

    beforeAll (done) ->

      associatedCompounds = new glados.models.Aggregations.Aggregation
        index_url: indexUrl
        query_config: queryConfig
        target_chembl_id: targetChemblID
        aggs_config: aggsConfig

      $.get (glados.Settings.STATIC_URL + 'testData/AggregationMinMaxSampleResponseSc1.json'), (testData) ->
        minMaxTestData = testData
        done()

    it 'initializes correctly', ->

      expect(associatedCompounds.url).toBe(indexUrl)
      expect(associatedCompounds.get('state'))\
      .toBe(glados.models.Aggregations.Aggregation.States.INITIAL_STATE)

      queryGot = associatedCompounds.get('query')
      expect(queryGot.multi_match?).toBe(true)
      expect(queryGot.multi_match.query).toBe(targetChemblID)
      expect(TestsUtils.listsAreEqual(queryGot.multi_match.fields, queryConfig.fields)).toBe(true)

    it 'Generates the request data to get min and max', ->

      requestData = associatedCompounds.getRequestMinMaxData()

      expect(requestData.aggs.x_axis_agg_max.max.field).toBe(currentXAxisProperty)
      expect(requestData.aggs.x_axis_agg_min.min.field).toBe(currentXAxisProperty)

      chemblIDis = requestData.query.multi_match.query
      chemblIDMustBe = associatedCompounds.get('target_chembl_id')
      expect(chemblIDis).toBe(chemblIDMustBe)

    it 'Parses the min and max data', ->

      console.log 'fetching'
      associatedCompounds.fetch()
      console.log 'parse test data: ', minMaxTestData

      minValue = 153.18
      maxValue = 565.33
      minColumns = 1
      maxColumns = 20

      parsedObj = associatedCompounds.parseMinMax(minMaxTestData)
      expect(parsedObj.aggs.x_axis_agg.max_value).toBe(maxValue)
      expect(parsedObj.aggs.x_axis_agg.min_value).toBe(minValue)

      maxBinSizeMustBe = parseFloat((Math.ceil(Math.abs(maxValue - minValue)) / minColumns).toFixed(2))
      minBinSizeMustBe = parseFloat((Math.ceil(Math.abs(maxValue - minValue)) / maxColumns).toFixed(2))
      expect(parsedObj.aggs.x_axis_agg.max_bin_size).toBe(maxBinSizeMustBe)
      expect(parsedObj.aggs.x_axis_agg.min_bin_size).toBe(minBinSizeMustBe)







