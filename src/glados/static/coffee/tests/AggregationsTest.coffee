describe 'Aggregation', ->
  describe 'with a numeric property (Associated compounds for a target)', ->
    associatedCompounds = undefined
    minMaxTestData = undefined
    bucketsTestData = undefined
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
          num_columns: 10

    beforeAll (done) ->
      associatedCompounds = new glados.models.Aggregations.Aggregation
        index_url: indexUrl
        query_config: queryConfig
        target_chembl_id: targetChemblID
        aggs_config: aggsConfig
        test_mode: true

      $.get (glados.Settings.STATIC_URL + 'testData/AggregationMinMaxSampleResponseSc1.json'), (testData) ->
        minMaxTestData = testData
        done()

    beforeAll (done) ->

      $.get (glados.Settings.STATIC_URL + 'testData/AggegationBucketsSampleResponseSc1.json'), (testData) ->
        bucketsTestData = testData
        done()

    it 'initializes correctly', ->
      expect(associatedCompounds.url).toBe(indexUrl)
      expect(associatedCompounds.get('state'))\
        .toBe(glados.models.Aggregations.Aggregation.States.INITIAL_STATE)

      queryGot = associatedCompounds.get('query')
      expect(queryGot.multi_match?).toBe(true)
      expect(queryGot.multi_match.query).toBe(targetChemblID)
      expect(TestsUtils.listsAreEqual(queryGot.multi_match.fields, queryConfig.fields)).toBe(true)

    it 'Knows that it needs to get Min and Max', ->
      expect(associatedCompounds.needsMinAndMax()).toBe(true)

    it 'Generates the request data to get min and max', ->
      requestData = associatedCompounds.getRequestMinMaxData()

      expect(requestData.aggs.x_axis_agg_max.max.field).toBe(currentXAxisProperty)
      expect(requestData.aggs.x_axis_agg_min.min.field).toBe(currentXAxisProperty)

      chemblIDis = requestData.query.multi_match.query
      chemblIDMustBe = associatedCompounds.get('target_chembl_id')
      expect(chemblIDis).toBe(chemblIDMustBe)

    it 'Parses the min and max data', ->
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


    it 'Generates the request data', ->

      aggsWithMinMax =
        aggs:
          x_axis_agg:
            field: "molecule_properties.full_mwt"
            type: "RANGE"
            min_columns: 1
            max_columns: 20
            num_columns: 10
            min_value: 153.18
            max_value: 565.33
            min_bin_size: 20.65
            max_bin_size: 413

      associatedCompounds.set('aggs_config', aggsWithMinMax)
      requestData = associatedCompounds.getRequestData()
      expect(requestData.aggs.x_axis_agg.range.field).toBe(currentXAxisProperty)

      requestDataAggs = requestData.aggs
      aggs = aggsWithMinMax.aggs
      for aggKey, aggDescription of aggs
        if aggDescription.type == glados.models.Aggregations.Aggregation.AggTypes.RANGE

          minValueMustBe = aggDescription.min_value
          maxValueMustBe = aggDescription.max_value
          numColsMustBe = aggDescription.num_columns

          rangesGot = requestDataAggs[aggKey].range.ranges
          expect(rangesGot.length).toBe(numColsMustBe)
          firstRangeFrom = rangesGot[0].from
          expect(firstRangeFrom).toBe(minValueMustBe)
          lastRangeTo = rangesGot[rangesGot.length-1].to
          expect(lastRangeTo >= maxValueMustBe).toBe(true)

      chemblIDis = requestData.query.multi_match.query
      chemblIDMustBe = associatedCompounds.get('target_chembl_id')
      expect(chemblIDis).toBe(chemblIDMustBe)

    it 'parses the bucket data', ->

      parsedObj = associatedCompounds.parse(bucketsTestData)
      bucketsShouldBe = bucketsTestData.aggregations.x_axis_agg.buckets
      bucketsGot = parsedObj.x_axis_agg.buckets

      for key, bucket of bucketsGot
        keyGot = bucket.key
        bucketShouldBe = bucketsShouldBe[keyGot]
        expect(bucketShouldBe?).toBe(true)

      expect(parsedObj.x_axis_agg.num_columns).toBe(Object.keys(bucketsShouldBe).length)

    it 'changes the field for an aggregation', ->

      newPropertyName = 'molecule_properties.alogp'
      associatedCompounds.changeFieldForAggregation('x_axis_agg', newPropertyName)

      aggsConfigGot = associatedCompounds.get('aggs_config').aggs
      aggConfigGot = aggsConfigGot.x_axis_agg

      expect(aggConfigGot.field).toBe(newPropertyName)

    it 'changes the number of columns for an aggregation', ->

      newNumColumns = 5
      associatedCompounds.changeNumColumnsForAggregation('x_axis_agg', newNumColumns)

      aggsConfigGot = associatedCompounds.get('aggs_config').aggs
      aggConfigGot = aggsConfigGot.x_axis_agg

      expect(aggConfigGot.num_columns).toBe(newNumColumns)

    it 'changes the bin size for an aggregation', ->

      newbinSize = 180
      associatedCompounds.changeBinSizeForAggregation('x_axis_agg', newbinSize)

      aggsConfigGot = associatedCompounds.get('aggs_config').aggs.x_axis_agg
      aggConfigGot = aggsConfigGot
      expect(aggConfigGot.bin_size).toBe(newbinSize)
      expect(aggConfigGot.intervals_set_by_bin_size).toBe(true)

    it 'cleans up the configuration for an aggregation', ->

      aggsConfig = associatedCompounds.get('aggs_config').aggs
      aggConfig = aggsConfig.x_axis_agg

      associatedCompounds.cleanUpRangeAggConfig(aggConfig)
      expect(aggConfig.max_bin_size?).toBe(false)
      expect(aggConfig.min_bin_size?).toBe(false)
      expect(aggConfig.max_value?).toBe(false)
      expect(aggConfig.min_value?).toBe(false)


  describe 'with a categorical property (Associated bioactivities for a target)', ->

    associatedBioactivities = undefined
    bucketsTestData = undefined
    indexUrl = glados.models.Aggregations.Aggregation.ACTIVITY_INDEX_URL
    currentField = 'standard_type'
    targetChemblID = 'CHEMBL2111342'

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: 'target_chembl_id:{{target_chembl_id}}'
      template_data:
        target_chembl_id: 'target_chembl_id'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: currentField
          size: 20

    beforeAll (done) ->
      associatedBioactivities = new glados.models.Aggregations.Aggregation
        index_url: indexUrl
        query_config: queryConfig
        target_chembl_id: targetChemblID
        aggs_config: aggsConfig
        test_mode: true

      $.get (glados.Settings.STATIC_URL + 'testData/AggregationBucketsSampleResponseSc2.json'), (testData) ->
        bucketsTestData = testData
        done()

    it 'initializes correctly', ->

      queryStringMustBe = 'target_chembl_id:CHEMBL2111342'

      expect(associatedBioactivities.url).toBe(indexUrl)
      expect(associatedBioactivities.get('state'))\
        .toBe(glados.models.Aggregations.Aggregation.States.INITIAL_STATE)

      queryGot = associatedBioactivities.get('query')
      expect(queryGot.query_string?).toBe(true)
      expect(queryGot.query_string.query).toBe(queryStringMustBe)

    it 'Knows that it does not need to get Min and Max', ->
      expect(associatedBioactivities.needsMinAndMax()).toBe(false)

    it 'Generates the request data', ->

      requestData = associatedBioactivities.getRequestData()
      expect(requestData.aggs.types.terms.field).toBe(currentField)
      expect(requestData.aggs.types.terms.size).toBe(aggsConfig.aggs.types.size)

    it 'parses the bucket data', ->

      parsedObj = associatedBioactivities.parse(bucketsTestData)
      bucketsShouldBe = bucketsTestData.aggregations.types.buckets
      bucketsGot = parsedObj.types.buckets

      for key, bucket of bucketsGot
        keyGot = bucket.key
        bucketShouldBe = bucketsShouldBe[keyGot]
        expect(bucketShouldBe?).toBe(true)

      expect(parsedObj.types.num_columns).toBe(Object.keys(bucketsShouldBe).length)



