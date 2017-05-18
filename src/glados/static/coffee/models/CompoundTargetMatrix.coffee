CompoundTargetMatrix = Backbone.Model.extend

  initialize: ->


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

  getValuesListForProperty: (propName) ->

    values = []

    for rowIndex, row of @get('matrix').links
      for colIndex, cell of row
        value = cell[propName]
        if value?
          values.push(value)

    return values

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