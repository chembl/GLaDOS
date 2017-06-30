describe "Target", ->

  describe "Target Model", ->

    target = new Target
        target_chembl_id: 'CHEMBL2363965'

    beforeAll (done) ->
      target.fetch()

      # this timeout is to give time to get the
      # target classification information, it happens after the fetch,
      # there is a way to know that it loaded at least one classification: get('protein_classifications_loaded')
      # but there is no way to know that it loaded all the classifications.
      setTimeout ( ->
        done()
      ), 10000

    it "(SERVER DEPENDENT) loads the protein target classification", (done) ->
      classification = target.get('protein_classifications')
      class1 = classification[8][0]
      class2 = classification[601][0]
      expect(class1).toBe('Other cytosolic protein')
      expect(class2).toBe('Unclassified protein')

      done()

  describe "Associated Compounds", ->

    associatedCompounds = undefined
    currentXAxisProperty = undefined
    minMaxTestData = undefined
    bucketsTestData = undefined
    numberOfColumns = 10

    beforeAll (done) ->

      associatedCompounds = new glados.models.Target.TargetAssociatedCompounds
        target_chembl_id: 'CHEMBL2111342'

      currentXAxisProperty = 'molecule_properties.full_mwt'
      associatedCompounds.set('current_xaxis_property', currentXAxisProperty)
      associatedCompounds.set('num_columns', numberOfColumns)

      $.get (glados.Settings.STATIC_URL + 'testData/AssociatedCompundsMinMaxSampleResponse.json'), (testData) ->
        minMaxTestData = testData
        done()

    beforeAll (done) ->

      $.get (glados.Settings.STATIC_URL + 'testData/AssociatedCompoundsBucketsSampleResponse.json'), (testData) ->
        bucketsTestData = testData
        done()

    it 'Generates the request data to get min and max', ->

      requestData = associatedCompounds.getRequestMinMaxData()
      expect(requestData.aggs.max_agg.max.field).toBe(currentXAxisProperty)
      expect(requestData.aggs.min_agg.min.field).toBe(currentXAxisProperty)

    it 'Parses the min and max data', ->
      parsedObj = associatedCompounds.parseMinMax(minMaxTestData)
      expect(parsedObj.max_value).toBe(13020.3)
      expect(parsedObj.min_value).toBe(4)


    it 'Generates the request data', ->

      associatedCompounds.set('min_value', 4)
      associatedCompounds.set('max_value', 13020.3)
      requestData = associatedCompounds.getRequestData()
      expect(requestData.aggs.x_axis_agg.range.field).toBe(currentXAxisProperty)

      minValue = associatedCompounds.get('min_value')
      maxValue = associatedCompounds.get('max_value')
      numColumns = associatedCompounds.get('num_columns')

      ranges = requestData.aggs.x_axis_agg.range.ranges
      expect(ranges.length).toBe(numColumns)
      firstRangeFrom = ranges[0].from
      expect(firstRangeFrom).toBe(minValue)
      lastRangeTo = ranges[ranges.length-1].to
      expect(lastRangeTo >= maxValue).toBe(true)

    it 'parses the bucket data', ->

      parsedObj = associatedCompounds.parse(bucketsTestData)
      console.log 'parsedObj: ', parsedObj
#      bucketsShouldBe = bucketsTestData.aggregations.x_axis_agg.buckets
#      bucketsGot = parsedObj.buckets
#
#      for i in [0..bucketsShouldBe.length-1]
#        expect(bucketsGot[i].key).toBe(bucketsShouldBe[i].key)
#        expect(bucketsGot[i].doc_count).toBe(bucketsShouldBe[i].doc_count)