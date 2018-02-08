describe "Utils", ->

  describe "Round numbers", ->

    testRoundNumbersForFactor = (factor, numbersMustBe) ->
      console.log 'Round Examples factor: ' + factor

      cur_i = -500
      last_up_v = null
      last_down_v = null
      while cur_i <= 500
        up_v = glados.Utils.roundNumber(cur_i, false, false)
        down_v = glados.Utils.roundNumber(cur_i, false, true)

        id = JSON.stringify(cur_i/factor)
        valuesGot = numbersMustBe[id]

        if up_v == down_v and (up_v != last_up_v or down_v != last_down_v)
          expect(valuesGot[0]).toBe(up_v)
        else if up_v != down_v and (up_v != last_up_v or down_v != last_down_v)
          expect(valuesGot[0]).toBe(up_v)
          expect(valuesGot[1]).toBe(down_v)
        last_up_v = up_v
        last_down_v = down_v
        cur_i++

    it 'rounds the numbers for factor 1', ->

      rangesMustBe = {"0":[0],"1":[1,0],"2":[2],"3":[5,2],"5":[5],"6":[10,5],"10":[10],"11":[20,10],"20":[20],"21":[50,20],"50":[50],"51":[100,50],"100":[100],"101":[200,100],"200":[200],"201":[500,200],"500":[500],"-500":[-500],"-200":[-200],"-100":[-100],"-50":[-50],"-20":[-20],"-10":[-10],"-5":[-5],"-2":[-2],"-1":[-1]}
      testRoundNumbersForFactor(1, rangesMustBe)
      rangesMustBe = {"0":[0],"1":[100],"2":[200],"5":[500],"-5":[-500],"-2":[-200],"-1":[-100],"-0.5":[-50],"-0.2":[-20],"-0.1":[-10],"-0.05":[-5],"-0.02":[-2],"-0.01":[-1],"0.01":[1,0],"0.02":[2],"0.03":[5,2],"0.05":[5],"0.06":[10,5],"0.1":[10],"0.11":[20,10],"0.2":[20],"0.21":[50,20],"0.5":[50],"0.51":[100,50],"1.01":[200,100],"2.01":[500,200]}
      testRoundNumbersForFactor(100.0, rangesMustBe)
      rangesMustBe = {"0":[0],"-0.05":[-500],"-0.02":[-200],"-0.01":[-100],"-0.005":[-50],"-0.002":[-20],"-0.001":[-10],"-0.0005":[-5],"-0.0002":[-2],"-0.0001":[-1],"0.0001":[1,0],"0.0002":[2],"0.0003":[5,2],"0.0005":[5],"0.0006":[10,5],"0.001":[10],"0.0011":[20,10],"0.002":[20],"0.0021":[50,20],"0.005":[50],"0.0051":[100,50],"0.01":[100],"0.0101":[200,100],"0.02":[200],"0.0201":[500,200],"0.05":[500]}
      testRoundNumbersForFactor(10000.0, rangesMustBe)

  it 'converts radians to degrees', ->

    expect(glados.Utils.getDegreesFromRadians(Math.PI)).toBe(180)
    expect(glados.Utils.getDegreesFromRadians(Math.PI/2)).toBe(90)

  describe "Nested values", ->

    describe "When all data is available", ->

      testObj = {}
      beforeAll (done) ->

        $.getJSON(glados.Settings.STATIC_URL + 'testData/CHEMBL25Attributes.json').done (testData) ->
          testObj = testData
          done()

      it 'Retrieves a nested value from an object', ->

        expect(glados.Utils.getNestedValue(testObj, 'availability_type')).toBe('2')
        expect(glados.Utils.getNestedValue(testObj, 'biotherapeutic')).toBe(glados.Settings.DEFAULT_NULL_VALUE_LABEL)
        expect(glados.Utils.getNestedValue(testObj, 'molecule_properties.acd_logd')).toBe('-1.68')

    describe "When some parent items are null", ->

      testObj = {}
      beforeAll (done) ->

        $.getJSON(glados.Settings.STATIC_URL + 'testData/CHEMBL2107978Attributes.json').done (testData) ->
          testObj = testData
          done()

      it 'Retrieves a nested value from an object', ->

        expect(glados.Utils.getNestedValue(testObj, 'molecule_properties')).toBe(glados.Settings.DEFAULT_NULL_VALUE_LABEL)
        expect(glados.Utils.getNestedValue(testObj, 'molecule_properties.acd_logd')).toBe(glados.Settings.DEFAULT_NULL_VALUE_LABEL)

      it 'Return nulls instead of null value label when requested', ->

        valueGot = glados.Utils.getNestedValue(testObj, 'molecule_properties', forceAsNumber=false,
          customNullValueLabel=undefined, returnUndefined=true)
        expect(valueGot).toBe(undefined)

        valueGot = glados.Utils.getNestedValue(testObj, 'molecule_properties.acd_logd', forceAsNumber=false,
          customNullValueLabel=undefined, returnUndefined=true)
        expect(valueGot).toBe(undefined)

  describe "Columns and values", ->

    testCompound = new Compound
    beforeAll (done) ->

      $.getJSON(glados.Settings.STATIC_URL + 'testData/CHEMBL25Attributes.json').done (testData) ->
        testCompound.set(testCompound.parse(testData))
        done()

    it 'generates columns and values for chembl25', ->

      columns = Compound.COLUMNS_SETTINGS.TEST
      colsWithVals = glados.Utils.getColumnsWithValues(columns, testCompound)

      for col in colsWithVals
        expect(col.value?).toBe(true)

      expect(colsWithVals[0].has_link).toBe(true)
      expect(colsWithVals[0].img_url).toBe("https://www.ebi.ac.uk/chembl/api/data/image/CHEMBL25.svg?engine=indigo")
      expect(colsWithVals[0].link_url).toBe("/compound_report_card/CHEMBL25")
      expect(colsWithVals[0].name_to_show).toBe("ChEMBL ID")
      expect(colsWithVals[0].value).toBe("CHEMBL25")

      expect(colsWithVals[1].has_link).toBe(false)
      expect(colsWithVals[1].name_to_show).toBe("Name")
      expect(colsWithVals[1].value).toBe("ASPIRIN")

      expect(colsWithVals[2].has_link).toBe(false)
      expect(colsWithVals[2].name_to_show).toBe("Max Phase")
      expect(colsWithVals[2].value).toBe(4)

    it 'obtains img url for chembl25', ->

      columns = Compound.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD
      colsWithVals = glados.Utils.getColumnsWithValues(columns, testCompound)

      expect(glados.Utils.getImgURL(colsWithVals)).toBe("https://www.ebi.ac.uk/chembl/api/data/image/CHEMBL25.svg?engine=indigo")

  describe "Buckets", ->

    generateRandomBuckets = (numBuckets) ->

      buckets = []
      for i in [1..numBuckets]
        buckets.push
          key: 'bucket' + i
          doc_count: parseInt(Math.random() * 1000)

      return buckets

    generateBucketsWithSubBuckets = (numBuckets, numSumBuckets, subBucketsAggName) ->

      buckets = []
      for i in [1..numBuckets]

        newBucket =
          key: 'bucket' + i
          doc_count: 1

        newBucket[subBucketsAggName] = {}
        newBucket[subBucketsAggName].buckets = []
        subBucketsContainer = newBucket[subBucketsAggName].buckets

        for j in [1..numSumBuckets]

          subBucket =
            key: "bucket-#{j}"
            doc_count: j

          subBucketsContainer.push subBucket

        buckets.push newBucket

      return buckets


    it 'gets sub buckets correctly', ->

      subBucketsAggName = 'split_series_agg'

      testBucketsWithSubBuckets = generateBucketsWithSubBuckets(2, 20, subBucketsAggName)
      newBucketsWithSubBuckets =  glados.Utils.Buckets.getSubBuckets(testBucketsWithSubBuckets, subBucketsAggName)

      newBucketsWithSubBucketsList = _.sortBy( _.values(newBucketsWithSubBuckets), (item) -> item.pos )

      currentCount = Number.MAX_VALUE

      for bucket in newBucketsWithSubBucketsList
        bucketCount = bucket.count
        expect(bucketCount <= currentCount ).toBe(true)
        currentCount = bucketCount

    it 'merges buckets with from a maximum number of categories', ->

      numBuckets = 10
      padding = 5

      # for now it is not necessary that it works with maxbuckets = 1
      for maxBuckets in [2..numBuckets+padding]
        testBuckets = generateRandomBuckets(numBuckets)
        newBuckets = glados.Utils.Buckets.mergeBuckets(testBuckets, maxBuckets)

        totalCountMustBe = _.reduce(_.pluck(testBuckets, 'doc_count'), ((a, b) -> a + b))
        totalCountGot = _.reduce(_.pluck(newBuckets, 'doc_count'), ((a, b) -> a + b))
        expect(totalCountMustBe).toBe(totalCountGot)

        totalBucketsGot = newBuckets.length
        expect(totalBucketsGot <= maxBuckets).toBe(true)

  describe "Query Strings", ->

    it 'generates a querystring for a list of compound chembl ids', ->

      idAttribute = 'molecule_chembl_id'

      chemblIDs = ["CHEMBL277500", "CHEMBL1332267", "CHEMBL1449337", "CHEMBL1531487", "CHEMBL1741626", "CHEMBL1881764", "CHEMBL1893751", "CHEMBL1966526", "CHEMBL1995935", "CHEMBL2003799", "CHEMBL2132226", "CHEMBL3833355", "CHEMBL3833360", "CHEMBL3833364"]
      qs = glados.Utils.QueryStrings.getQueryStringForItemsList(chemblIDs, idAttribute)

      listGot = qs.replace(idAttribute + ':(', '').replace(')', '').replace(/"/g, '').split(' OR ')

      for i in [0..listGot.length-1]
        expect(listGot[i]).toBe(chemblIDs[i])

  describe "Columns Parsing", ->

    describe 'with link function', ->

      testCol =
        name_to_show: 'UniProt Accession'
        comparator: 'target_components'
        sort_disabled: false
        is_sorting: 0
        sort_class: 'fa-sort'
        parse_function: (components) -> (comp.accession for comp in components).join(', ')
        link_function: (components) ->
          'http://www.uniprot.org/uniprot/?query=' + ('accession:' + comp.accession for comp in components).join('+OR+')

      testColumns = [testCol]
      testTarget = new Target()

      beforeAll (done) ->
        dataURL =  glados.Settings.STATIC_URL + 'testData/TargetCHEMBL3301393TestData.json'
        TestsUtils.simulateDataModel(testTarget, dataURL, done)

      it 'generates the correct values', ->

        columnsWithValuesGot = glados.Utils.getColumnsWithValues(testColumns, testTarget)
        expect(columnsWithValuesGot[0].value).toBe('P61794, Q8K5E0')
        expect(columnsWithValuesGot[0].link_url).toBe('http://www.uniprot.org/uniprot/?query=accession:P61794+OR+accession:Q8K5E0')

  describe "Fetching Utils", ->

    it 'fetches a model only once', ->

      testTarget = new Target
        target_chembl_id: 'CHEMBL2111359'

      spyOn(testTarget, 'fetch')
      glados.Utils.Fetching.fetchModelOnce(testTarget)
      glados.Utils.Fetching.fetchModelOnce(testTarget)
      glados.Utils.Fetching.fetchModelOnce(testTarget)
      expect(testTarget.fetch).toHaveBeenCalledTimes(1)

