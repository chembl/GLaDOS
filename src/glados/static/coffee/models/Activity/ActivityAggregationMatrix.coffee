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

    #-------------------------------------------------------------------------------------------------------------------
    # Parsing
    #-------------------------------------------------------------------------------------------------------------------
    parse: (data) ->

      rowsToPosition = {}
      colsToPosition = {}
      links = {}

      rowsList = []
      latestRowPos = 0
      colsList = []
      latestColPos = 0

      rowsIndex = {}
      columnsIndex = {}

      aggregations = @get('aggregations')
      rowsAggName = aggregations[0] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX
      colsAggName = aggregations[1] + glados.models.Activity.ActivityAggregationMatrix.AGG_SUFIX

      rowsBuckets = data.aggregations[rowsAggName].buckets

      for rowBucket in rowsBuckets

        # what do I know now? I am seeing a new compound
        rowID = rowBucket.key

        # remember that  the orgiginalIndex and currentPosition are used to sort easily the nodes.
        rowObj = @createNewRowObj(rowID, rowBucket, latestRowPos)

        rowsList.push rowObj
        rowsToPosition[rowID] = latestRowPos
        latestRowPos++

        # now check the targets for this molecule
        colBuckets = rowBucket[colsAggName].buckets
        for colBucket in colBuckets

          # what do I know now? there is a target, it could be new or repeated
          colID = colBucket.key
          colPos = colsToPosition[colID]

          # it is new!
          if not colPos?

            colObj = @createNewColObj(colID, colBucket, latestColPos)

            colsList.push colObj
            colsToPosition[colID] = latestColPos
            latestColPos++
          # it is not new, I just need to update the row properties
          else
            colObj = colsList[colPos]

          # now I know that there is a new intersection!
          cellObj = @createNewCellObj(rowID, colID, colBucket)

          #update row and col properties
          @updateColOrRowObj(rowObj, colBucket)
          @updateColOrRowObj(colObj, colBucket)

          # here the compound and target must exist in the lists, recalculate the positions
          compPos = rowsToPosition[rowID]
          colPos = colsToPosition[colID]

          # create object for storing links if not yet there
          if not links[compPos]?
            links[compPos] = {}

          links[compPos][colPos] = cellObj

      result =
        columns: colsList
        rows: rowsList
        links: links
        rows_index: _.indexBy(rowsList, 'id')
        columns_index: _.indexBy(colsList, 'id')

      console.log 'result: ', result

      return {"matrix": result}

    createNewRowObj: (rowID, rowBucket, latestRowPos) ->

      aggregations = @get('aggregations')
      if aggregations[0] == 'molecule_chembl_id'
        @createNewCompObj(rowID, rowBucket, latestRowPos)
      else
        @createTargObj(rowID, rowBucket, latestRowPos)

    createNewColObj: (colID, colBucket, latestColPos) ->

      aggregations = @get('aggregations')
      if aggregations[0] == 'target_chembl_id'
        @createNewTargObj(colID, colBucket, latestColPos)
      else
        @createNewCompObj(colID, colBucket, latestColPos)

    createNewCompObj: (id, bucket, latestPos) ->
      return {
        id: id
        molecule_pref_name: 'MOL_NAME ' + latestPos
        molecule_chembl_id: bucket.key
        originalIndex: latestPos
        currentPosition: latestPos
        activity_count: 0
        pchembl_value_max: null
        hit_count: 0
      }

    createNewTargObj: (id, bucket, latestPos) ->

      return {
        id: id
        pref_name: @LOADING_DATA_LABEL
        target_chembl_id: bucket.key
        originalIndex: latestPos
        currentPosition: latestPos
        activity_count: 0
        pchembl_value_max: null
        hit_count: 0
      }


    createNewCellObj: (rowID, colID, colBucket) ->
      row_id: rowID
      col_id: colID
      activity_count: colBucket.doc_count
      pchembl_value_avg: colBucket.pchembl_value_avg.value
      pchembl_value_max: colBucket.pchembl_value_max.value

    updateColOrRowObj: (obj, colBucket) ->

      obj.activity_count += colBucket.doc_count
      obj.hit_count++

      newPchemblMax = colBucket.pchembl_value_max.value
      currentPchemblMax = obj.pchembl_value_max

      if not currentPchemblMax?
        obj.pchembl_value_max = newPchemblMax
      else if newPchemblMax?
        obj.pchembl_value_max = Math.max(newPchemblMax, currentPchemblMax)


    #-------------------------------------------------------------------------------------------------------------------
    # Additional data
    #-------------------------------------------------------------------------------------------------------------------
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