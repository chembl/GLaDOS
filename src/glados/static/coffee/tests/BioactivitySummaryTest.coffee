describe "BioactivitySummary", ->

  describe "From a selection of targets", ->

    it 'Generates the request data', ->

      activitiesSummarylist = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewBioactivitiesSummaryList()

      possibleComparators = ['cvkwe', "trbde", "xcysj", "kocnf", "tfaed", "isjxd", "vzvkx", "ukaum", "gsqki", "awxeq",
        "ktxmj"]

      testComparators = _.sample(possibleComparators, 3)
      activitiesSummarylist.setMeta('default_comparators', testComparators)
      activitiesSummarylist.setMeta('current_comparators', testComparators)
      requestData = activitiesSummarylist.getRequestData()

      numLevels = testComparators.length
      currentAgg = requestData.aggs
      for i in [1..numLevels]
        currentComparator = testComparators[i-1]
        currentAggNameShouldBe = currentComparator + '_agg'
        expect(currentAgg[currentAggNameShouldBe]?).toBe(true)
        expect(currentAgg[currentAggNameShouldBe].terms.field).toBe(currentComparator)
        currentAgg = currentAgg[currentAggNameShouldBe].aggs
