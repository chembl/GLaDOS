describe 'Aggregation', ->

  describe 'with a numeric property (Associated compounds for a target)', ->

    associatedCompoundsAggregation = undefined
    indexUrl = glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
    targetChemblID = 'CHEMBL2111342'
    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'target_chembl_id'
      fields: ['_metadata.related_targets.chembl_ids.*']


    beforeAll ->

      associatedCompoundsAggregation = new glados.models.Aggregations.Aggregation
        index_url: indexUrl
        query_config: queryConfig
        target_chembl_id: targetChemblID

    it 'initializes correctly', ->

      expect(associatedCompoundsAggregation.get('index_url')).toBe(indexUrl)
      expect(associatedCompoundsAggregation.get('state'))\
      .toBe(glados.models.Aggregations.Aggregation.States.INITIAL_STATE)

      queryGot = associatedCompoundsAggregation.get('query')
      expect(queryGot.multi_match?).toBe(true)
      expect(queryGot.multi_match.query).toBe(targetChemblID)
      expect(TestsUtils.listsAreEqual(queryGot.multi_match.fields, queryConfig.fields)).toBe(true)




