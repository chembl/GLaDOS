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