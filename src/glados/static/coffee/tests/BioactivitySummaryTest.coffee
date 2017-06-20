describe "BioactivitySummary", ->

  describe "From a selection of targets", ->

    activitiesSummarylist = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewBioactivitiesSummaryList()
    sampleResponse = undefined

    beforeAll (done) ->
      dataURL = glados.Settings.STATIC_URL + 'testData/TargetBioactivitySummarySampleResponse.json'
      $.get dataURL, (testData) ->
        sampleResponse = testData
        done()

    it 'Generates the request data', ->

      possibleComparators = ['cvkwe', "trbde", "xcysj", "kocnf", "tfaed", "isjxd", "vzvkx", "ukaum", "gsqki", "awxeq",
        "ktxmj"]

      testComparators = _.sample(possibleComparators, 3)
      activitiesSummarylist.setMeta('default_comparators', testComparators)
      activitiesSummarylist.setMeta('current_comparators', testComparators)
      requestData = activitiesSummarylist.getRequestData()

      numLevels = testComparators.length
      currentAgg = requestData.aggs
      for i in [1..numLevels]
        currentComparator = testComparators[i-1]
        currentAggNameShouldBe = currentComparator + '_agg'
        expect(currentAgg[currentAggNameShouldBe]?).toBe(true)
        expect(currentAgg[currentAggNameShouldBe].terms.field).toBe(currentComparator)
        currentAgg = currentAgg[currentAggNameShouldBe].aggs

    it 'loads the list form an elasticsearch response', ->

      activitiesSummarylist.parse(sampleResponse)
      models = activitiesSummarylist.models

      proportions = {}

      getProportionsFromBucket = (bucket, keyName, proportions) ->

        aggregations = _.filter(Object.keys(bucket), (key) -> key.search('_agg$') != -1)

        if aggregations.length == 0
          numToAdd = 1
        else
          numToAdd = 0
          for aggKey in aggregations
            currentAggData = bucket[aggKey]
            for currentBucket in currentAggData.buckets
              numToAdd += getProportionsFromBucket(currentBucket, aggKey, proportions)


        currentPropertyName = if keyName.search('_agg$') != -1 then keyName.split('_agg')[0] else keyName
        currentPropertyValue = bucket.key

        if not proportions[currentPropertyName]?
          proportions[currentPropertyName] = {}
        if not proportions[currentPropertyName][currentPropertyValue]?
          proportions[currentPropertyName][currentPropertyValue] = 0
        if not proportions[currentPropertyName]['total']?
          proportions[currentPropertyName]['total'] = 0

        proportions[currentPropertyName][currentPropertyValue] += numToAdd
        proportions[currentPropertyName]['total'] += numToAdd

        return numToAdd

      rootBucket = {key: true}
      for aggKey, value of sampleResponse.aggregations
          rootBucket[aggKey] = value

      getProportionsFromBucket(rootBucket, Activity.COLUMNS.IS_AGGREGATION.comparator, proportions)

      for propName, possibleValues of proportions
        groupedValues = _.groupBy(models, (model) -> model.attributes[propName])
        for propValue, count of possibleValues
          if propValue != 'total'
            expectedProportion = (count/possibleValues['total'])
            proportionGot = (groupedValues[propValue].length/models.length)
            expect(proportionGot).toBe(expectedProportion)


