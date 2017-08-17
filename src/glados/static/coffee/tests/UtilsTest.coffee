describe "Utils", ->

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