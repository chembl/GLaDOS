glados.useNameSpace 'glados.models.Activity',
  ActivityAggregationMatrix: Backbone.Model.extend

    defaults:
      filter_property: 'molecule_chembl_id'
      aggregations: ['molecule_chembl_id', 'target_chembl_id']

    initialize: ->

    fetch: (options) ->

      @url = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_activity/_search'
      # Creates the Elastic Search Query parameters and serializes them
      esJSONRequest = JSON.stringify(@getRequestData())
      console.log 'esJSONRequest: ', esJSONRequest
      fetchESOptions =
        url: @url
        data: esJSONRequest
        type: 'POST'
        reset: true

      thisModel = @
      $.ajax(fetchESOptions).done((data) ->
        thisModel.set(thisModel.parse data)
        allTargets = thisModel.get('matrix').columns
        for target in allTargets
          chemblID = target.target_chembl_id
          thisModel.loadTargetsPrefName(chemblID)
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
        compID = moleculeBucket.key

        # remember that  the orgiginalIndex and currentPosition are used to sort easily the nodes.
        newCompoundObj =
          id: compID
          molecule_pref_name: 'MOL_NAME ' + latestCompPos
          molecule_chembl_id: moleculeBucket.key
          originalIndex: latestCompPos
          currentPosition: latestCompPos
          activity_count: 0
          pchembl_value_max: null
          hit_count: moleculeBucket.target_chembl_id_agg.buckets.length

        compoundsList.push newCompoundObj
        compoundsToPosition[compID] = latestCompPos
        latestCompPos++

        # now check the targets for this molecule
        targBuckets = moleculeBucket.target_chembl_id_agg.buckets
        for targetBucket in targBuckets

          # what do I know now? there is a target, it could be new or repeated
          targID = targetBucket.key
          targPos = targetsToPosition[targID]

          # it is new!
          if not targPos?

            newTargetObj =
              id: targID
              pref_name: @LOADING_DATA_LABEL
              target_chembl_id: targetBucket.key
              originalIndex: latestTargPos
              currentPosition: latestTargPos
              activity_count: targetBucket.doc_count
              pchembl_value_max: null
              hit_count: 1


            targetsList.push newTargetObj
            targetsToPosition[targID] = latestTargPos
            latestTargPos++

          # it is not new, I just need to update the row properties
          else

            targObj = targetsList[targPos]

            targObj.activity_count += targetBucket.doc_count
            targObj.hit_count++

            newPchemblMax = targObj.pchembl_value_max
            currentPchemblMax = targetBucket.pchembl_value_max.value
            if not currentRowPchemblMax?
              targObj.pchembl_value_max = newPchemblMax
            else if newPchemblMax?
              targObj.pchembl_value_max = Math.max(targetBucket.pchembl_value_max.value, targObj.pchembl_value_max)

          # now I know that there is a new intersection!
          activities =
            row_id: compID
            col_id: targID
            activity_count: targetBucket.doc_count
            pchembl_value_avg: targetBucket.pchembl_value_avg.value
            pchembl_value_max: targetBucket.pchembl_value_max.value

          # update the row properties
          newCompoundObj.activity_count += targetBucket.doc_count

          newPchemblMax = targetBucket.pchembl_value_max.value
          currentRowPchemblMax = newCompoundObj.pchembl_value_max
          if not currentRowPchemblMax?
            newCompoundObj.pchembl_value_max = newPchemblMax
          else if newPchemblMax?
            newCompoundObj.pchembl_value_max = Math.max(newPchemblMax, currentRowPchemblMax)

          # here the compound and target must exist in the lists, recalculate the positions
          compPos = compoundsToPosition[compID]
          targPos = targetsToPosition[targID]

          # create object for storing columns if not yet there
          if not links[compPos]?
            links[compPos] = {}

          links[compPos][targPos] = activities

      result =
        columns: targetsList
        rows: compoundsList
        links: links
        rows_index: _.indexBy(compoundsList, 'id')
        columns_index: _.indexBy(targetsList, 'id')

      console.log 'result: ', result



      return {"matrix": result}

    loadTargetsPrefName: (targetChemblID) ->

      targetUrl = glados.Settings.WS_BASE_URL + 'target/' + targetChemblID + '.json'
      thisModel = @
      $.getJSON(targetUrl).done( (data) ->
        targetPrefName = data.pref_name
        targetToUpdate = thisModel.get('matrix').columns_index[targetChemblID]
        targetToUpdate.pref_name = targetPrefName
      ).fail( ->
        targetToUpdate = thisModel.get('matrix').columns_index[targetChemblID]
        targetToUpdate.pref_name = thisModel.ERROR_LOADING_DATA_LABEL
      ).always(-> thisModel.trigger(glados.models.Activity.ActivityAggregationMatrix.TARGET_PREF_NAMES_UPDATED_EVT, targetChemblID))

    getValuesListForProperty: (propName) ->

      values = []

      for rowIndex, row of @get('matrix').links
        for colIndex, cell of row
          value = cell[propName]
          values.push(value) unless not value?

      return values

    sortMatrixRowsBy: (propName, reverse=false) ->

      matrix = @get('matrix')
      newOrders = _.sortBy(matrix.rows, propName)
      newOrders = newOrders.reverse() if reverse
      #avoid issues with inconsistency of the objects pointed
      matrix.rows = []
      for row, index in newOrders
        matrix.rows_index[row.id].currentPosition = index
        matrix.rows.push(matrix.rows_index[row.id])

    sortMatrixColsBy: (propName, reverse=false) ->

      matrix = @get('matrix')
      newOrders = _.sortBy(matrix.columns, propName)
      newOrders = newOrders.reverse() if reverse
      matrix.columns = []
      for col, index in newOrders
        matrix.columns_index[col.id].currentPosition = index
        matrix.columns.push(matrix.columns_index[col.id])

    #returns a list with all the links
    getDataList: ->

      dataList = []
      for rowID, row of @get('matrix').links
        for colID, cell of row
          dataList.push cell

      return dataList

    #-------------------------------------------------------------------------------------------------------------------
    # Request data
    #-------------------------------------------------------------------------------------------------------------------
    addQueryToRequest: (requestData, idsList) ->
      requestData.query =
        terms: {}

      requestData.query.terms[@get('filter_property')] = idsList

    addAggregationsToRequest: (requestData) ->

      aggsList = @get('aggregations')
      requestData.aggs = {}
      aggsContainer = requestData.aggs
      for propName in aggsList
        aggName = propName + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
        aggsContainer[aggName] =
          terms:
            field: propName,
            size: 10,
            order:
              _count: "desc"
          aggs: {}

        aggsContainer = aggsContainer[aggName].aggs

    addCellAggregationsToRequest: (requestData) ->

      aggsList = @get('aggregations')
      aggsContainer = requestData.aggs

      for i in [0..aggsList.length-1]
        propName = aggsList[i]
        aggName = propName + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
        if i != aggsList.length - 1
          aggsContainer = aggsContainer[aggName].aggs
        else
          aggsContainer[aggName].aggs =
            pchembl_value_avg:
              avg:
                field: "pchembl_value"
            pchembl_value_max:
              max:
                field: "pchembl_value"

    getRequestData: ->

      idsList = @get('chembl_ids')

      requestData =
        size: 0

      @addQueryToRequest(requestData, idsList)
      @addAggregationsToRequest(requestData)
      @addCellAggregationsToRequest(requestData)

      console.log 'requestData: ', requestData
      console.log JSON.stringify(requestData)
      return requestData

glados.models.Activity.ActivityAggregationMatrix.LOADING_DATA_LABEL = 'Loading...'
glados.models.Activity.ActivityAggregationMatrix. ERROR_LOADING_DATA_LABEL = '(Error Loading data)'
glados.models.Activity.ActivityAggregationMatrix.TARGET_PREF_NAMES_UPDATED_EVT = 'TARGET_PREF_NAMES_UPDATED_EVT'
glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX = '_agg'