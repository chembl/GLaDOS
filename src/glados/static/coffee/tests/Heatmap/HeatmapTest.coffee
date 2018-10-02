describe "Heatmap", ->
  # See
  # https://docs.google.com/drawings/d/18dPoA2wI1q62aBWMOBYAVQ7TIza_Mbk28yxL6hK10nE/edit?usp=sharing
  # https://docs.google.com/drawings/d/1hbmanZRe6VHKpHCoCtPfcCM3Er8d4TCeveOz2Rm3QaI/edit?usp=sharing
  # https://docs.google.com/drawings/d/1XuJ9947pq0nkOBlixAWTiLaVRxN1mBYC--FUlDIXbyI/edit?usp=sharing
  # https://docs.google.com/drawings/d/1QoG5OPFewKQ5I2N3-My83hKKQOScM8_Lc5SRAD1D7zM/edit?usp=sharing
  # https://docs.google.com/drawings/d/1_K7JTZDZYPw0i_hLy-ApYsNI264edBrJmoDetG2FgVw/edit?usp=sharing

  describe 'When x-axis list is the generator list', ->

    generatorList = undefined

    beforeAll (done) ->

      $.get (glados.Settings.STATIC_URL + 'testData/Heatmap/Case0/GeneratorList/state.json'), (state) ->
        generatorList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFromState(state)

        itemsURL = glados.Settings.STATIC_URL + 'testData/Heatmap/Case0/GeneratorList/items.json'
        TestsUtils.simulateDataESList(generatorList, itemsURL, done)

    # Start from the list created from the results of searching by dopamine
    it 'generates the dependent lists from the generator list', ->

