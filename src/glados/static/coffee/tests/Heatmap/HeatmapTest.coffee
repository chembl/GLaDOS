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
    heatmap = undefined

    beforeAll (done) ->

      $.get (glados.Settings.STATIC_URL + 'testData/Heatmap/Case0/GeneratorList/state.json'), (state) ->
        generatorList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFromState(state)

        config =
          generator_list: generatorList
          generator_axis: glados.models.Heatmap.AXES_NAMES.Y_AXIS
          generate_from_downloaded_items: true
          opposite_axis_generator_function: (itemsIDS) ->


            esQuery = {
              "query": {
                "bool": {
                  "filter": {
                    "bool": {
                      "should": [
                        {
                          "multi_match": {
                            "query": "CHEMBL25",
                            "fields": "_metadata.related_compounds.chembl_ids.*"
                          }
                        },
                        {
                          "multi_match": {
                            "query": "CHEMBL59",
                            "fields": "_metadata.related_compounds.chembl_ids.*"
                          }
                        }
                      ]

                    }
                  }
                }
              }
            }
            console.log('esQuery: ', esQuery)

            targetsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESTargetsList(
              JSON.stringify(esQuery)
            )

            targetsList.fetch()
            console.log 'GENERATE OPPOSITE AXIS: ', itemsIDS
            console.log 'targetsList: ', targetsList

        heatmap = new glados.models.Heatmap.Heatmap
          config: config

        itemsURL = glados.Settings.STATIC_URL + 'testData/Heatmap/Case0/GeneratorList/items.json'
        TestsUtils.simulateDataESList(generatorList, itemsURL, done)

    it 'is initialised with the initial state', ->

      state = heatmap.get('state')
      expect(state).toBe(glados.models.Heatmap.STATES.INITIAL_STATE)

    it 'generates the dependent lists from the generator list', ->

      console.log 'heatmap: ', heatmap

