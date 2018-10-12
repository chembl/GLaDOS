describe "Heatmap", ->
  # See
  # https://docs.google.com/drawings/d/18dPoA2wI1q62aBWMOBYAVQ7TIza_Mbk28yxL6hK10nE/edit?usp=sharing
  # https://docs.google.com/drawings/d/1hbmanZRe6VHKpHCoCtPfcCM3Er8d4TCeveOz2Rm3QaI/edit?usp=sharing
  # https://docs.google.com/drawings/d/1XuJ9947pq0nkOBlixAWTiLaVRxN1mBYC--FUlDIXbyI/edit?usp=sharing
  # https://docs.google.com/drawings/d/1QoG5OPFewKQ5I2N3-My83hKKQOScM8_Lc5SRAD1D7zM/edit?usp=sharing
  # https://docs.google.com/drawings/d/1_K7JTZDZYPw0i_hLy-ApYsNI264edBrJmoDetG2FgVw/edit?usp=sharing

  describe 'When x-axis list is the generator list', ->

    # Start from the list created from the results of searching by dopamine

    generatorList = undefined
    config = undefined

    beforeAll (done) ->

      $.get (glados.Settings.STATIC_URL + 'testData/Heatmap/Case0/GeneratorList/state.json'), (state) ->
        generatorList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFromState(state)

        configGenerator = new glados.configs.ReportCards.Visualisation.Heatmaps.CompoundsVSTargetsHeatmap(generatorList)
        config = configGenerator.getHeatmapModelConfig(generatorList)
        config.test_mode = true

        itemsURL = glados.Settings.STATIC_URL + 'testData/Heatmap/Case0/GeneratorList/items.json'
        TestsUtils.simulateDataESList(generatorList, itemsURL, done)

    it 'is initialised with the initial state', ->

      heatmap = new glados.models.Heatmap.Heatmap
        config: config

      state = heatmap.get('state')
      expect(state).toBe(glados.models.Heatmap.STATES.INITIAL_STATE)

    it 'generates the dependent lists from the generator list', ->

      heatmap = new glados.models.Heatmap.Heatmap
          config: config

      heatmap.once 'change:state', ->
        currentState = heatmap.get('state')
        if currentState == glados.models.Heatmap.STATES.DEPENDENT_LISTS_CREATED
          generatorIDs = (res.molecule_chembl_id for res in heatmap.y_axis_list.allResults)
          i = 0
          for boolQuery in heatmap.x_axis_list.getRequestData().query.bool.should
            idsInQuery = boolQuery.bool.filter.terms["_metadata.related_compounds.chembl_ids.#{i}"]
            expect(_.isEqual(idsInQuery, generatorIDs)).toBe(true)
            i += 1

      heatmap.generateDependentLists()



