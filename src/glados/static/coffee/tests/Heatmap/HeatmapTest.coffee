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
        config = configGenerator.getHeatmapModelConfig()
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

    describe 'Load Window', ->

      it 'initialises the load Window Structure', ->

        heatmap = new glados.models.Heatmap.Heatmap
          config: config

        heatmap.setInitialWindow()
        loadWindowStruct = heatmap.get('load_window_struct')
        for axis in ['x_axis', 'y_axis']
          expect(loadWindowStruct[axis].loading_frontiers.length).toBe(0)
          expect(loadWindowStruct[axis].loaded_frontiers.length).toBe(0)
          expect(loadWindowStruct[axis].error_frontiers.length).toBe(0)

      # https://docs.google.com/drawings/d/1ThMJMcRUoAPtMU984iwcT1g3sJpE6zJy5589LyzqwfI/edit?usp=sharing
      describe 'workflow 0. Simple loading window', ->

        heatmap = undefined

        beforeAll (done) ->

          configGenerator = new glados.configs.ReportCards.Visualisation.Heatmaps.CompoundsVSTargetsHeatmap(generatorList)
          config = configGenerator.getHeatmapModelConfig()
          config.test_mode = true
          config.custom_w_factor = 2

          heatmap = new glados.models.Heatmap.Heatmap
            config: config

          heatmap.once 'change:state', ->

            #here the dependent list has been generated
            dependentList = heatmap.x_axis_list

            itemsURL = glados.Settings.STATIC_URL + 'testData/Heatmap/Case0/DependentList/items.json'
            TestsUtils.simulateDataESList(dependentList, itemsURL, done)

          heatmap.generateDependentLists()
          heatmap.setInitialWindow()

        beforeEach ->

          heatmap.resetLoadWindow()
          heatmap.createMatrixInitialStructure()
          heatmap.set('min_window_load_size_factor', glados.models.Heatmap.LOAD_WINDOW.MIN_LOAD_SIZE_WINDOW_FACTOR)


        it 'generates the correct frontier with no window movement, just window created at different points', ->

          heatmap.set('min_window_load_size_factor', 0)
          currentWFactor = heatmap.get('w_factor')

          axis = glados.models.Heatmap.AXES_NAMES.X_AXIS
          axisLength = heatmap.x_axis_list.getTotalRecords()

          # test a the smallest visual window length possible, a normal length, and a size bigger than the axis.
          for visualWindowLength in [1, 40, (axisLength + 1)]

            # test for windows outside the axes,
            for testVisualWindow in ({start:i, end:(i + visualWindowLength - 1)} for i in [-visualWindowLength..axisLength+visualWindowLength])

              visualWindowStart = testVisualWindow.start
              visualWindowEnd = testVisualWindow.end

              heatmap.informVisualWindowLimits(axis, visualWindowStart, visualWindowEnd)
              loadWindowStruct = heatmap.get('load_window_struct')

              toLoadFrontierGot = loadWindowStruct.x_axis.to_load_frontiers[0]
              startMustBe = visualWindowStart - Math.ceil(((visualWindowLength * currentWFactor)\
                - visualWindowLength)/2)
              startMustBe = 1 if startMustBe < 1
              startMustBe = axisLength if startMustBe > axisLength

              endMustBe = visualWindowEnd + Math.floor(((visualWindowLength * currentWFactor)\
                - visualWindowLength)/2)
              endMustBe = 1 if endMustBe < 1
              endMustBe = axisLength if endMustBe > axisLength

              expect(toLoadFrontierGot.start).toBe(startMustBe)
              expect(toLoadFrontierGot.end).toBe(endMustBe)

              heatmap.resetLoadWindow()

        it 'processes the window structure, basic case', ->

          start = 1
          end = 3

          loadWindow =
            start: start
            end: end

          loadWindowStruct = heatmap.get('load_window_struct')
          loadWindowStruct.x_axis.to_load_frontiers.push loadWindow
          heatmap.processLoadWindowStruct()

          # the frontier should expand
          loadingFrontiersGot = loadWindowStruct.x_axis.loading_frontiers
          loadingFrontierGot = loadingFrontiersGot[0]
          expect(loadingFrontierGot.start).toBe(loadWindow.start)
          expect(loadingFrontierGot.end).toBe(loadWindow.end)

          # the items new state should be marked
          matrix = heatmap.get('matrix')
          columns = matrix.columns

          i = 1
          for col in columns
            if start <= i <= end
              expect(col.load_state).toBe(glados.models.Heatmap.ITEM_LOAD_STATES.LOADING)
            else
              expect(col.load_state).toBe(glados.models.Heatmap.ITEM_LOAD_STATES.TO_LOAD)
            i += 1


      describe 'Window chopping', ->

        heatmap = undefined

        beforeAll (done) ->

          configGenerator = new glados.configs.ReportCards.Visualisation.Heatmaps.CompoundsVSTargetsHeatmap(generatorList)
          config = configGenerator.getHeatmapModelConfig()
          config.test_mode = true
          config.custom_w_factor = 2

          heatmap = new glados.models.Heatmap.Heatmap
            config: config

          heatmap.once 'change:state', ->

            #here the dependent list has been generated
            dependentList = heatmap.x_axis_list

            itemsURL = glados.Settings.STATIC_URL + 'testData/Heatmap/Case0/DependentList/items.json'
            TestsUtils.simulateDataESList(dependentList, itemsURL, done)

          heatmap.generateDependentLists()
          heatmap.setInitialWindow()

        beforeEach ->

          heatmap.resetLoadWindow()
          heatmap.createMatrixInitialStructure()

        # see https://docs.google.com/drawings/d/16w9CrAilksh9CGr1OTRLTl3pUvxhP7eLGGt4MrDzugU/edit?usp=sharing
        it 'Chops correctly a load candidate, with no minimum load size', ->

          console.log 'FAILING TEST'
          heatmap.set('min_window_load_size_factor', 0)
          matrix = heatmap.get('matrix')
          axis = glados.models.Heatmap.AXES_NAMES.X_AXIS

          loadWindowStruct = heatmap.get('load_window_struct')
          # create frontiers like in the drawing
          loadingFrontier1 =
            start: 10
            end: 13
          loadWindowStruct.x_axis.loading_frontiers.push loadingFrontier1

          loadingFrontier2 =
            start: 21
            end: 23
          loadWindowStruct.x_axis.loading_frontiers.push loadingFrontier2

          loadedFrontier1 =
            start: 24
            end: 25
          loadWindowStruct.x_axis.loaded_frontiers.push loadedFrontier1

          loadedFrontier2 =
            start: 31
            end: 35
          loadWindowStruct.x_axis.loaded_frontiers.push loadedFrontier2

          heatmap.informVisualWindowLimits(axis, 15, 29)

          toLoadFrontiersGot = loadWindowStruct.x_axis.to_load_frontiers
          toLoadFrontiersDict = _.indexBy(toLoadFrontiersGot, (f) -> "#{f.start}-#{f.end}")

          toLoadFrontiersMustBe = []

          toLoadFrontierMustBe1 =
            start: 7
            end: 9
          toLoadFrontiersMustBe.push toLoadFrontierMustBe1

          toLoadFrontierMustBe2 =
            start: 14
            end: 20
          toLoadFrontiersMustBe.push toLoadFrontierMustBe2

          toLoadFrontierMustBe3 =
            start: 26
            end: 30
          toLoadFrontiersMustBe.push toLoadFrontierMustBe3

          for frontier in toLoadFrontiersMustBe

            toLoadFrontierGot = toLoadFrontiersDict["#{frontier.start}-#{frontier.end}"]
            expect(toLoadFrontierGot?).toBe(true)


        it 'Chops correctly a load candidate with minimum load size', ->

          heatmap.set('min_window_load_size_factor', glados.models.Heatmap.LOAD_WINDOW.MIN_LOAD_SIZE_WINDOW_FACTOR)
          matrix = heatmap.get('matrix')
          axis = glados.models.Heatmap.AXES_NAMES.X_AXIS

          loadWindowStruct = heatmap.get('load_window_struct')
          # create frontiers like in the drawing
          loadingFrontier1 =
            start: 10
            end: 13
          loadWindowStruct.x_axis.loading_frontiers.push loadingFrontier1

          loadingFrontier2 =
            start: 21
            end: 23
          loadWindowStruct.x_axis.loading_frontiers.push loadingFrontier2

          loadedFrontier1 =
            start: 24
            end: 25
          loadWindowStruct.x_axis.loaded_frontiers.push loadedFrontier1

          loadedFrontier2 =
            start: 31
            end: 35
          loadWindowStruct.x_axis.loaded_frontiers.push loadedFrontier2

          heatmap.informVisualWindowLimits(axis, 15, 29)

          toLoadFrontiersGot = loadWindowStruct.x_axis.to_load_frontiers
          #none of the frontiers should survive
          expect(toLoadFrontiersGot.length).toBe(0)

        # https://docs.google.com/drawings/d/1SgJq0rUku8XHDGKYQdJWYJ57mosGATsi5cAfpivI3jI/edit?usp=sharing
        it 'Joins correctly the gaps between the frontiers', ->

          heatmap.set('min_window_load_size_factor', glados.models.Heatmap.LOAD_WINDOW.MIN_LOAD_SIZE_WINDOW_FACTOR)
          matrix = heatmap.get('matrix')

          loadWindowStruct = heatmap.get('load_window_struct')
          # create frontiers like in the drawing
          toLoadFrontier1 =
            start: 7
            end: 8
          loadWindowStruct.x_axis.to_load_frontiers.push toLoadFrontier1

          toLoadFrontier2 =
            start: 14
            end: 16
          loadWindowStruct.x_axis.to_load_frontiers.push toLoadFrontier2

          toLoadFrontier3 =
            start: 20
            end: 20
          loadWindowStruct.x_axis.to_load_frontiers.push toLoadFrontier3

          toLoadFrontier4 =
            start: 26
            end: 27
          loadWindowStruct.x_axis.to_load_frontiers.push toLoadFrontier4

          toLoadFrontier5 =
            start: 30
            end: 30
          loadWindowStruct.x_axis.to_load_frontiers.push toLoadFrontier5

          toLoadFrontier6 =
            start: 36
            end: 36
          loadWindowStruct.x_axis.to_load_frontiers.push toLoadFrontier6

          loadingFrontier1 =
            start: 10
            end: 13
          loadWindowStruct.x_axis.loading_frontiers.push loadingFrontier1

          loadingFrontier2 =
            start: 21
            end: 23
          loadWindowStruct.x_axis.loading_frontiers.push loadingFrontier2

          loadedFrontier1 =
            start: 24
            end: 25
          loadWindowStruct.x_axis.loaded_frontiers.push loadedFrontier1

          loadedFrontier2 =
            start: 31
            end: 35
          loadWindowStruct.x_axis.loaded_frontiers.push loadedFrontier2

          heatmap.removeToLoadGaps()

          toLoadFrontiersGot = loadWindowStruct.x_axis.to_load_frontiers
          toLoadFrontiersDict = _.indexBy(toLoadFrontiersGot, (f) -> "#{f.start}-#{f.end}")

          toLoadFrontiersMustBe = []

          toLoadFrontierMustBe1 =
            start: 7
            end: 9
          toLoadFrontiersMustBe.push toLoadFrontierMustBe1

          toLoadFrontierMustBe2 =
            start: 14
            end: 20
          toLoadFrontiersMustBe.push toLoadFrontierMustBe2

          toLoadFrontierMustBe3 =
            start: 26
            end: 30
          toLoadFrontiersMustBe.push toLoadFrontierMustBe3

          for frontier in toLoadFrontiersMustBe

            toLoadFrontierGot = toLoadFrontiersDict["#{frontier.start}-#{frontier.end}"]
            expect(toLoadFrontierGot?).toBe(true)

        it 'Does not produce any to load frontier when no gaps', ->

          heatmap.set('min_window_load_size_factor', glados.models.Heatmap.LOAD_WINDOW.MIN_LOAD_SIZE_WINDOW_FACTOR)
          matrix = heatmap.get('matrix')

          axis = glados.models.Heatmap.AXES_NAMES.X_AXIS
          heatmap.informVisualWindowLimits(axis, 15, 29)

          loadWindowStruct = heatmap.get('load_window_struct')
          toLoadFrontiersGot = loadWindowStruct.x_axis.to_load_frontiers
          expect(toLoadFrontiersGot.length).toBe(1)

