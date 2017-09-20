describe 'Aggregation', ->

  describe 'with a numeric property (Associated compounds for a target)', ->

    associatedCompounds = undefined
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

    beforeAll ->

      associatedCompounds = new glados.models.Aggregations.Aggregation
        index_url: indexUrl
        query_config: queryConfig
        target_chembl_id: targetChemblID
        aggs_config: aggsConfig

    it 'initializes correctly', ->

      expect(associatedCompounds.get('index_url')).toBe(indexUrl)
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




