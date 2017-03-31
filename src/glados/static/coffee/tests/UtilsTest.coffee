describe "Utils", ->

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

      columns = Compound.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD
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