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
      initial_colouring: 'assay_type'
      colour_properties: ['pchembl_value', 'assay_type', 'published_value']
      initial_row_sorting: 'pchembl_value'
      initial_row_sorting_reverse: true
      row_sorting_properties: ['pchembl_value', 'published_value']
      initial_col_sorting: 'published_value'
      initial_col_sorting_reverse: true
      col_sorting_properties: ['pchembl_value', 'published_value']
      propertyToType:
        assay_type: "string"
        pchembl_value: "number"
        published_value: "number"
    }

    config = {
      initial_colouring: 'activity_count'
      colour_properties: ['activity_count', 'pchembl_value_avg']
      initial_row_sorting: 'activity_count'
      initial_row_sorting_reverse: true
      row_sorting_properties: ['activity_count', 'pchembl_value_max']
      initial_col_sorting: 'activity_count'
      initial_col_sorting_reverse: true
      col_sorting_properties: ['activity_count', 'pchembl_value_max']
      propertyToType:
        activity_count: "number"
        pchembl_value_avg: "number"
        pchembl_value_max: "number"
    }



    @set('config', config)

# This fetch uses a post to get the information, to avoid any issue with the lenght of the url due to the ammount of
# compounds
  fetch: (options) ->
    @fetch2(options)
    return

    idsList = @get('molecule_chembl_ids')
    console.log 'IDS list: ', idsList

    url = 'https://www.ebi.ac.uk/chembl/api/data/activity.json'
    activities = []
    totalItems = idsList.length
    chunkSize = 400
    totalPages = Math.ceil(totalItems / chunkSize)
    # temporarily limit the amount of items to get, the retrieval of the information needs more discussion
    maxItems = 400

    thisModel = @
    getAllItemsJson = (page) ->
      start = (page - 1) * chunkSize
      end = start + chunkSize - 1
      if end >= idsList.length
        end = idsList.length - 1

      itemsToGet = idsList[start..end]

      data = 'limit=' + chunkSize + '&' + 'molecule_chembl_id__in=' + itemsToGet.join(',')

      console.log 'FETCHING'
      console.log 'totalPages: ', totalPages
      console.log 'totalItems: ', totalItems
      console.log 'data: ', totalItems

      $.ajax(
        type: 'POST'
        url: url
        data: data
        headers:
          'X-HTTP-Method-Override': 'GET'
      ).done((response) ->
        for newActivity in response.activities
          activities.push newActivity
        console.log 'response!'
        console.log response

        percentage = Math.ceil((page / totalPages) * 100)
        console.log 'downloaded: ', percentage, '%'

        # check if I still have more pages to go, temporarily limit the ammount of items to get.
        if activities.length < maxItems
          getAllItemsJson (page + 1)
        else
# if not, I have finished!
          console.log 'finished!'
          console.log activities.length + ' activities.'
          console.log activities
          thisModel.set(thisModel.parse activities)
      )

    # get everything from page 1
    getAllItemsJson 1

  parse: (activities) ->
    console.log 'data received!'

    config = @get('config')
    console.log activities.length + ' activities.'

    compoundsToPosition = {}
    targetsToPosition = {}
    links = {}

    compoundsList = []
    latestCompPos = 0
    targetsList = []
    latestTargPos = 0

    for act in activities
      currentCompound = act.molecule_chembl_id
      currentTarget = act.target_chembl_id

      if act.target_pref_name.length > 10
        currentTargetName = act.target_pref_name.slice(0, 10) + '...' + ' (' + act.target_chembl_id + ')'
      else
        currentTargetName = act.target_pref_name + ' (' + act.target_chembl_id + ')'

      targPos = targetsToPosition[currentTarget]
      compPos = compoundsToPosition[currentCompound]

      # add compound

      # It doesn't exist? create a new one.
      if not compPos?
# remember that  the orgiginalIndex and currentPosition are used to sort easily the nodes.
        newCompoundObj = {label: currentCompound, originalIndex: latestCompPos, currentPosition: latestCompPos}

        # this is a new one, initialise it with the first value
        for property in config.col_sorting_properties
          if act[property]?
            newCompoundObj[(property + '_sum')] = parseFloat(act[property])
          else
            newCompoundObj[(property + '_sum')] = 0

        compoundsList.push newCompoundObj
        compoundsToPosition[currentCompound] = latestCompPos
        latestCompPos++

# it does exist, get it and sum the sorting properties
      else
        compObj = compoundsList[compPos]
        # this is an existing one, sum the property!
        for property in config.col_sorting_properties
          if act[property]?
            compObj[(property + '_sum')] += parseFloat(act[property])

      #-----
      # add target
      if not targPos?
        newTargetObj = {label: currentTargetName, originalIndex: latestTargPos, currentPosition: latestTargPos}
        targetsList.push newTargetObj
        targetsToPosition[currentTarget] = latestTargPos
        latestTargPos++

        # this is a new one, initialise it with the first value
        for property in config.row_sorting_properties
          if act[property]?
            newTargetObj[(property + '_sum')] = parseFloat(act[property])
          else
            newTargetObj[(property + '_sum')] = 0
      else
        targObj = targetsList[targPos]
        for property in config.row_sorting_properties
          if act[property]?
            targObj[(property + '_sum')] += parseFloat(act[property])


      # here the compound and target must exist in the lists, recalculate the positions
      compPos = compoundsToPosition[currentCompound]
      targPos = targetsToPosition[currentTarget]

      if not links[compPos]?
        links[compPos] = {}

      act['row_id'] = act.molecule_chembl_id
      act['col_id'] = act.target_chembl_id
      links[compPos][targPos] = act

    result =
      "columns": targetsList
      "rows": compoundsList
      "links": links

    console.log 'data processed!'
    console.log 'result: ', result

    return {"matrix": result}

  fetch2: (options) ->
    console.log 'FETCH 2'
    @url = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_activity/_search'
    console.log @url
    # Creates the Elastic Search Query parameters and serializes them
    esJSONRequest = JSON.stringify(@getRequestData())
    console.log esJSONRequest
    fetchESOptions =
      url: @url
      data: esJSONRequest
      type: 'POST'
      reset: true

    console.log 'going to make request:', fetchESOptions
    thisModel = @
    $.ajax(fetchESOptions).done((data) ->
      thisModel.set(thisModel.parse2 data)
    )

  parse2: (data) ->

    console.log 'parse new data!'
    console.log data

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

          targetsList.push newTargetObj
          targetsToPosition[targLabel] = latestTargPos
          latestTargPos++

        # it is not new, I just need to update the row properties
        else

           targObj = targetsList[targPos]
           targObj.activity_count += targetBucket.doc_count
           targObj.pchembl_value_max = Math.max(targetBucket.pchembl_value_max.value, targObj.pchembl_value_max)

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

    console.log 'compoundsList', compoundsList
    console.log 'targetsList', targetsList
    console.log 'links', links

    result =
      "columns": targetsList
      "rows": compoundsList
      "links": links

    console.log 'result: ', result

    return {"matrix": result}


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
            size: 5,
            order:
              _count: "desc"
          aggs:
            pchembl_value_max:
              max:
                field: "pchembl_value"
            target_chembl_id_agg:
              terms:
                field: "target_chembl_id",
                size: 5,
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