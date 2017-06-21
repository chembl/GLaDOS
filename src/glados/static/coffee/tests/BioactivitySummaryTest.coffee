describe "BioactivitySummary", ->

  describe "From a selection of targets", ->

    activitiesSummarylist = undefined
    sampleResponse = undefined

    beforeEach ->

      activitiesSummarylist = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewBioactivitiesSummaryList()

    beforeAll (done) ->

      dataURL = glados.Settings.STATIC_URL + 'testData/TargetBioactivitySummarySampleResponse.json'
      $.get dataURL, (testData) ->
        sampleResponse = testData
        done()

    it 'tells if the origin ids have changed', ->

      attrName = 'metaListHasChanged'
      expect(activitiesSummarylist.metaListHasChanged(attrName)).toBe(false)
      idsList1 = ['a','b','c']
      idsList2 = ['a','b','c', 'd', 'e']
      idsList3 = ['a','b','d']

      activitiesSummarylist.setMeta(attrName, idsList1, undefined, trackPreviousValue=true)
      expect(activitiesSummarylist.metaListHasChanged(attrName)).toBe(true)

      activitiesSummarylist.setMeta(attrName, undefined, undefined, trackPreviousValue=true)
      expect(activitiesSummarylist.metaListHasChanged(attrName)).toBe(true)

      activitiesSummarylist.setMeta(attrName, idsList1, undefined, trackPreviousValue=true)
      activitiesSummarylist.setMeta(attrName, idsList2, undefined, trackPreviousValue=true)
      expect(activitiesSummarylist.metaListHasChanged(attrName)).toBe(true)

      activitiesSummarylist.setMeta(attrName, idsList1, undefined, trackPreviousValue=true)
      activitiesSummarylist.setMeta(attrName, idsList3, undefined, trackPreviousValue=true)
      expect(activitiesSummarylist.metaListHasChanged(attrName)).toBe(true)

      activitiesSummarylist.setMeta(attrName, idsList1, undefined, trackPreviousValue=true)
      activitiesSummarylist.setMeta(attrName, idsList1, undefined, trackPreviousValue=true)
      expect(activitiesSummarylist.metaListHasChanged(attrName)).toBe(false)

    it 'Generates the request data', ->

      originChemblIDs = ["CHEMBL2111342","CHEMBL2111341","CHEMBL3102","CHEMBL2111359","CHEMBL2331075","CHEMBL3427","CHEMBL2304406","CHEMBL2097165","CHEMBL2095169","CHEMBL2096970","CHEMBL2093868","CHEMBL4702","CHEMBL2096910","CHEMBL3138","CHEMBL3071","CHEMBL2281","CHEMBL2096905","CHEMBL2095396","CHEMBL1850","CHEMBL339","CHEMBL3998","CHEMBL265","CHEMBL2368","CHEMBL3361"]
      activitiesSummarylist.setMeta('origin_chembl_ids', originChemblIDs)

      possibleComparators = ['cvkwe', "trbde", "xcysj", "kocnf", "tfaed", "isjxd", "vzvkx", "ukaum", "gsqki", "awxeq",
        "ktxmj"]
      testComparators = _.sample(possibleComparators, 3)
      activitiesSummarylist.setMeta('default_comparators', testComparators)
      activitiesSummarylist.setMeta('current_comparators', testComparators)
      requestData = activitiesSummarylist.getRequestData()

      chemblIDsInQuery = requestData.query.query_string.query.split('target_chembl_id:')[1]\
        .replace('(', '').replace(')', '').replace(/\"/g, '').split(' OR ')

      for i in [0..originChemblIDs.length-1]
        expect(chemblIDsInQuery[i]).toBe(originChemblIDs[i])

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

    it 'sets the correct columns after loading from response', ->

      activitiesSummarylist.parse(sampleResponse)
      currentComparators = activitiesSummarylist.getMeta('current_comparators')
      columns = activitiesSummarylist.getMeta('columns')
      for i in [0..currentComparators.length]
        # check that last is count!
        if i == currentComparators.length
          expect(columns[i].comparator).toBe('doc_count')
        else
          expect(currentComparators[i]).toBe(columns[i].comparator)
          expect(columns[i].show).toBe(true)

