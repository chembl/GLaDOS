CompoundTargetMatrix = Backbone.Model.extend

  initialize: ->
    @url = 'https://www.ebi.ac.uk/chembl/api/data/activity.json?limit=1000&molecule_chembl_id__in=CHEMBL554,CHEMBL212250,CHEMBL212201,CHEMBL212251,CHEMBL384407,CHEMBL387207,CHEMBL215814,CHEMBL383965,CHEMBL214487,CHEMBL212954,CHEMBL213342,CHEMBL215716,CHEMBL213818,CHEMBL212965,CHEMBL214023,CHEMBL265367,CHEMBL215171,CHEMBL214419,CHEMBL384711,CHEMBL380247,CHEMBL215993,CHEMBL377437,CHEMBL214689,CHEMBL213822,CHEMBL215033,CHEMBL445572,CHEMBL377250,CHEMBL490062,CHEMBL588324,CHEMBL528983,CHEMBL529972,CHEMBL528234,CHEMBL532686,CHEMBL546497,CHEMBL548563,CHEMBL1630107,CHEMBL1630111,CHEMBL1630113,CHEMBL1630117,CHEMBL1794063,CHEMBL2347565,CHEMBL2347566,CHEMBL2347567,CHEMBL2407820,CHEMBL3040455,CHEMBL3040543,CHEMBL3040548,CHEMBL3040566,CHEMBL3040597,CHEMBL3344208,CHEMBL3344209,CHEMBL3344210,CHEMBL3344211,CHEMBL3344212,CHEMBL3344213,CHEMBL3344214,CHEMBL3344215,CHEMBL3344216,CHEMBL3344217,CHEMBL3344218,CHEMBL3344219,CHEMBL3344220,CHEMBL3344221,CHEMBL3526263,CHEMBL3526326,CHEMBL3526479,CHEMBL3526480,CHEMBL3526609,CHEMBL3526763,CHEMBL3526764,CHEMBL3526765,CHEMBL3527094,CHEMBL3527095,CHEMBL3542267,CHEMBL3542268,CHEMBL3546948,CHEMBL3546949,CHEMBL3546966,CHEMBL3546967,CHEMBL3546968,CHEMBL3546969,CHEMBL3546976,CHEMBL3666714,CHEMBL3706535'
    #   @url = 'https://www.ebi.ac.uk/chembl/api/data/activity.json?limit=100&molecule_chembl_id__in=CHEMBL554,CHEMBL212250,CHEMBL212201,CHEMBL212251,CHEMBL384407,CHEMBL387207,CHEMBL215814,CHEMBL383965,CHEMBL214487,CHEMBL212954,CHEMBL213342,CHEMBL215716,CHEMBL213818,CHEMBL212965,CHEMBL214023,CHEMBL265367,CHEMBL215171,CHEMBL214419,CHEMBL384711,CHEMBL380247,CHEMBL215993,CHEMBL377437,CHEMBL214689,CHEMBL213822,CHEMBL215033,CHEMBL445572,CHEMBL377250,CHEMBL490062,CHEMBL588324,CHEMBL528983,CHEMBL529972,CHEMBL528234,CHEMBL532686,CHEMBL546497,CHEMBL548563,CHEMBL1630111,CHEMBL1630113,CHEMBL1630117,CHEMBL1794063,CHEMBL2347565,CHEMBL2347566,CHEMBL2347567,CHEMBL2407820,CHEMBL3040455,CHEMBL3040543,CHEMBL3040548,CHEMBL3040566,CHEMBL3040597,CHEMBL3344208,CHEMBL3344209,CHEMBL3344210,CHEMBL3344211,CHEMBL3344212,CHEMBL3344213,CHEMBL3344214,CHEMBL3344215,CHEMBL3344216,CHEMBL3344217,CHEMBL3344218,CHEMBL3344219,CHEMBL3344220,CHEMBL3344221,CHEMBL3526263,CHEMBL3526326,CHEMBL3526479,CHEMBL3526480,CHEMBL3526609,CHEMBL3526763,CHEMBL3526764,CHEMBL3526765,CHEMBL3527094,CHEMBL3527095,CHEMBL3542267,CHEMBL3542268,CHEMBL3546948,CHEMBL3546949,CHEMBL3546966,CHEMBL3546967,CHEMBL3546968,CHEMBL3546969,CHEMBL3546976,CHEMBL3666714,CHEMBL3706535'

    console.log @url

    # config used for testing
    #    config = {
    #      initial_colouring: 'assay_type'
    #      colour_properties: ['pchembl_value', 'assay_type', 'published_value']
    #      initial_row_sorting: 'pchembl_value'
    #      row_sorting_properties: ['pchembl_value', 'published_value']
    #      initial_col_sorting: 'published_value'
    #      col_sorting_properties: ['pchembl_value', 'published_value']
    #      propertyToType:
    #        assay_type: "string"
    #        pchembl_value: "number"
    #        published_value: "number"
    #    }

    config = {
      initial_colouring: 'pchembl_value_avg'
      colour_properties: ['activity_count', 'pchembl_value_avg']
      initial_row_sorting: 'activity_count'
      initial_row_sorting_reverse: true
      row_sorting_properties: ['activity_count', 'pchembl_value_max', 'hit_count']
      initial_col_sorting: 'activity_count'
      initial_col_sorting_reverse: true
      col_sorting_properties: ['activity_count', 'pchembl_value_max', 'hit_count']
      propertyToType:
        activity_count: "number"
        pchembl_value_avg: "number"
        pchembl_value_max: "number"
        hit_count: "number"
    }



    @set('config', config)

  fetch: (options) ->

    @url = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_activity/_search'
    # Creates the Elastic Search Query parameters and serializes them
    esJSONRequest = JSON.stringify(@getRequestData())

    fetchESOptions =
      url: @url
      data: esJSONRequest
      type: 'POST'
      reset: true

    thisModel = @
    $.ajax(fetchESOptions).done((data) ->
      thisModel.set(thisModel.parse data)
    )


  parse: (data) ->

    compoundsToPosition = {}
    targetsToPosition = {}
    links = {}

    compoundsList = []
    latestCompPos = 0
    targetsList = []
    latestTargPos = 0

    rowsIndex = {}
    columnsIndex = {}

    # start with the list of molecules from the aggregation
    molsBuckets = data.aggregations.molecule_chembl_id_agg.buckets

    for moleculeBucket in molsBuckets

      # what do I know now? I am seeing a new compound
      compLabel = moleculeBucket.key

      # remember that  the orgiginalIndex and currentPosition are used to sort easily the nodes.
      newCompoundObj =
        label: compLabel
        originalIndex: latestCompPos
        currentPosition: latestCompPos
        activity_count: moleculeBucket.doc_count
        pchembl_value_max: moleculeBucket.pchembl_value_max.value
        hit_count: moleculeBucket.target_chembl_id_agg.buckets.length

      compoundsList.push newCompoundObj
      compoundsToPosition[compLabel] = latestCompPos
      latestCompPos++

      # now check the targets for this molecule
      targBuckets = moleculeBucket.target_chembl_id_agg.buckets
      for targetBucket in targBuckets

        # what do I know now? there is a target, it could be new or repeated
        targLabel = 'Targ: ' + targetBucket.key
        targPos = targetsToPosition[targLabel]

        # it is new!
        if not targPos?

          newTargetObj =
            label: targLabel
            originalIndex: latestTargPos
            currentPosition: latestTargPos
            activity_count: targetBucket.doc_count
            pchembl_value_max: targetBucket.pchembl_value_max.value
            hit_count: 1


          targetsList.push newTargetObj
          targetsToPosition[targLabel] = latestTargPos
          latestTargPos++

        # it is not new, I just need to update the row properties
        else

           targObj = targetsList[targPos]
           targObj.activity_count += targetBucket.doc_count
           targObj.pchembl_value_max = Math.max(targetBucket.pchembl_value_max.value, targObj.pchembl_value_max)
           targObj.hit_count++

        # now I know that there is a new intersection!
        activities =
          row_id: compLabel
          col_id: targLabel
          activity_count: targetBucket.doc_count
          pchembl_value_avg: targetBucket.pchembl_value_avg.value


        # here the compound and target must exist in the lists, recalculate the positions
        compPos = compoundsToPosition[compLabel]
        targPos = targetsToPosition[targLabel]

        # create object for storing columns if not yet there
        if not links[compPos]?
          links[compPos] = {}

        links[compPos][targPos] = activities

    result =
      columns: targetsList
      rows: compoundsList
      links: links
      rows_index: _.indexBy(compoundsList, 'label')
      columns_index: _.indexBy(targetsList, 'label')

    console.log 'result: ', result

    return {"matrix": result}

  getLinkForColHeader: (itemID) ->
    return Target.get_report_card_url itemID.replace('Targ: ', '')

  getLinkForRowHeader: (itemID) ->
    return Compound.get_report_card_url(itemID)

  getRequestData: ->

    # just limit for now the ammount of data received
    if @get('molecule_chembl_ids').length < 1000
      idsList = @get('molecule_chembl_ids')
    else
      idsList = @get('molecule_chembl_ids')[0..1000]

    return {
      query:
        terms:
          molecule_chembl_id: idsList
      size: 0
      aggs:
        molecule_chembl_id_agg:
          terms:
            field: "molecule_chembl_id",
            size: 20,
            order:
              _count: "desc"
          aggs:
            pchembl_value_max:
              max:
                field: "pchembl_value"
            target_chembl_id_agg:
              terms:
                field: "target_chembl_id",
                size: 10,
                order:
                  _count: "desc"
              aggs:
                pchembl_value_avg:
                  avg:
                    field: "pchembl_value"
                pchembl_value_max:
                  max:
                    field: "pchembl_value"
                assay_type_agg:
                  terms:
                    field: "assay_type"
                    size: 100

    }