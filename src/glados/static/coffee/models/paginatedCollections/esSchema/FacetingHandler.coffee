glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Faceting Handler
  # --------------------------------------------------------------------------------------------------------------------
  FacetingHandler: class FacetingHandler

    # ------------------------------------------------------------------------------------------------------------------
    # Class Context
    # ------------------------------------------------------------------------------------------------------------------

    @CATEGORY_FACETING: 'CATEGORY'
    @INTERVAL_FACETING: 'INTERVAL'

    @NUM_INTERVALS: 8

    @EMPTY_CATEGORY: '- N/A -'
    @OTHERS_CATEGORY: 'Other Categories'
    @KEY_REGEX_REPLACE: /[^A-Z0-9_-]/gi

    @getAllFacetGroupsSelectedQuery: (faceting_handlers_list)->
      all_facets_query = []
      for faceting_handler_i in faceting_handlers_list
        fh_query_i = faceting_handler_i.getSelectedFacetsFilterQuery()
        if fh_query_i
          all_facets_query.push(fh_query_i)
      if all_facets_query.length == 0
        return null
      return all_facets_query

    # this takes some facet settings and initializes new facets group structure with a new faceting handler for
    # every facet group, independent from any other copy of facets generated usin the same settings object
    @initFacetGroups: (facetGroupsConfig) ->

      newFacets = $.extend({}, facetGroupsConfig)

      for fGroupKey, fGroup of newFacets

        esIndex = facetGroupsConfig[fGroupKey].es_index
        propName = facetGroupsConfig[fGroupKey].prop_name
        initialSort = facetGroupsConfig[fGroupKey].initial_sort
        initialIntervals = facetGroupsConfig[fGroupKey].initial_intervals
        reportCardEntity = facetGroupsConfig[fGroupKey].report_card_entity

        fGroup.faceting_handler = glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          esIndex, propName, initialSort, initialIntervals, reportCardEntity
        )

      return newFacets

    @generateFacetsForIndex: (es_index, defaults, defaults_hidden, exclude_patterns)->
      facets = {}
      if not _.has(glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema, es_index)
        throw 'ERROR: '+es_index+' was not found in the Generated Schema for GLaDOS!'
      gs_data = glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema[es_index]
      console.log('es_index: ', es_index)
      cur_pos = 1
      getFacetData = (prop_data, prop_name)->
        console.log('GET FACET DATA')
        sort = null
        intervals = null
        report_card_entity = null
        if _.isString(prop_data)
          prop_name = prop_data
        else if _.isObject(prop_data)
          prop_name = prop_data.property
          sort = prop_data.sort
          intervals = prop_data.intervals
          report_card_entity = prop_data.report_card_entity
        if prop_name not in _.keys(gs_data)
          throw 'ERROR: '+prop_name+' is not a property of '+es_index+'!'
        if gs_data[prop_name].aggregatable
          return {
            label: django.gettext(gs_data[prop_name].label_id)
            label_mini: django.gettext(gs_data[prop_name].label_mini_id)
            show: false
            position: cur_pos++
            es_index: es_index
            prop_name: prop_name
            initial_sort: sort
            initial_intervals: intervals
            report_card_entity: report_card_entity
            prop_id: prop_name
          }
        throw 'ERROR: '+prop_name+' is not an aggregatable property!'

      if defaults?
        for prop_i in defaults
          if _.isString(prop_i)
            prop_name = prop_i
          else if _.isObject(prop_i)
            prop_name = prop_i.property
          facets[prop_name] = getFacetData(prop_i, prop_name)
          facets[prop_name].show = true
      if defaults_hidden?
        for prop_i in defaults_hidden
          if _.isString(prop_i)
            prop_name = prop_i
          else if _.isObject(prop_i)
            prop_name = prop_i.property
          facets[prop_name] = getFacetData(prop_i, prop_name)
          facets[prop_name].show = false

      console.log('facets: ', facets)
      return facets

    @getNewFacetingHandler: (es_index, es_property, sort=null, intervals=null, report_card_entity=null)->
      es_index_schema =  glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema[es_index]
      if not es_index_schema
        throw "ERROR! unknown elastic index "+es_index
      property_type = es_index_schema[es_property]
      if not property_type
        throw "ERROR! unknown "+es_property+" for elastic index "+es_index
      if not property_type.aggregatable
        throw "ERROR! "+es_property+" for elastic index "+es_index+" is not aggregatable"
      if property_type.type == String or property_type.type == Boolean
        return new FacetingHandler(
          es_index,
          es_property,
          property_type.type,
          FacetingHandler.CATEGORY_FACETING,
          property_type,
          null,
          sort,
          intervals,
          report_card_entity
        )
      else if property_type.type == Number
        return new FacetingHandler(
          es_index,
          es_property,
          property_type.type,
          FacetingHandler.INTERVAL_FACETING,
          property_type,
          property_type.year,
          sort,
          intervals,
          report_card_entity
        )
      else
        throw "ERROR! "+es_property+" for elastic index "+es_index+" with type "+property_type.type\
            +" does not have a defined faceting type"

    # ------------------------------------------------------------------------------------------------------------------
    # Instance Context
    # ------------------------------------------------------------------------------------------------------------------

    constructor: (@es_index, @es_property_name, @js_type, @faceting_type, @property_type, @isYear, @sort=null,
      @intervals=null, @report_card_entity=null)->
      @faceting_keys_inorder = null
      @faceting_data = null
      @intervalsLimits = null

    # ------------------------------------------------------------------------------------------------------------------
    # State Saving
    # ------------------------------------------------------------------------------------------------------------------
    getStateJSON: ->

      state = JSON.parse(JSON.stringify(@))
      return state

    loadState: (stateJSON) -> $.extend(@, stateJSON)

    # ------------------------------------------------------------------------------------------------------------------
    # Query and Parse Facets to/from Elasticsearch
    # ------------------------------------------------------------------------------------------------------------------

    hasReportCardModel: -> @report_card_entity?

    # Interval aggregations require 2 calls to find out first the min/max/dev_std range
    # and then create an histogram of n columns
    addQueryAggs: (es_query_aggs, first_call)->
      if @faceting_type == FacetingHandler.CATEGORY_FACETING
        if first_call
          es_query_aggs[@es_property_name] = {
            terms:
              field: @es_property_name
          }
          if @intervals?
            es_query_aggs[@es_property_name].terms['size'] = @intervals
          # Elastic search has a bug for terms aggregation in booleans with missing values
          if @js_type != Boolean
            es_query_aggs[@es_property_name].terms.missing = FacetingHandler.EMPTY_CATEGORY

      else if @faceting_type == FacetingHandler.INTERVAL_FACETING
        if first_call
          es_query_aggs[@es_property_name+'_STATS'] = {
            extended_stats:
              field: @es_property_name
          }
          es_query_aggs[@es_property_name+'_PERCENTILES'] = {
            'filter': {
                'range':  {}
            }
            aggs: {}
          }
          filtered_aggs_query = es_query_aggs[@es_property_name+'_PERCENTILES']
          filtered_aggs_query.filter.range[@es_property_name]= {'gte': 7.62939453125e-6, 'lte': 1.073741824e9}
          filtered_aggs_query.aggs[@es_property_name+'_PERCENTILES'] = {
            percentiles:
              field: @es_property_name
              percents: [1,10,20,30,40,50,60,70,80,90,99]
              keyed: true
              hdr:
                number_of_significant_value_digits: 3
          }
        else
          if not @intervalsLimits?
            throw "ERROR! The intervals have not been calculated yet!"
          else
            es_query_aggs[@es_property_name] = {
              range:
                field: @es_property_name
                ranges: []
            }
            for intervalLimitI, index in @intervalsLimits
              if index == @intervalsLimits.length - 1
                continue
              es_query_aggs[@es_property_name].range.ranges.push
                from: intervalLimitI
                to: @intervalsLimits[index+1]

    calculateIntervals: (stats, percentiles)->
      # WARNING: Do the division first to prevent number overflow
      intervalsSize = (stats.max/FacetingHandler.NUM_INTERVALS)-(stats.min/FacetingHandler.NUM_INTERVALS)
      # WARNING: Do the division first to prevent number overflow

      lowP = percentiles['1.0']
      hiP = percentiles['99.0']

      isSmallFloat = hiP - lowP <= 7 and not @property_type.integer
      bound = 3/4*stats.std_deviation
      isNormalDistributed = hiP > stats.avg + bound and lowP < stats.avg - bound
      if isNormalDistributed
        isSmallFloat =  2*bound <= 7 and not @property_type.integer
      minV = stats.min
      maxV = stats.max

      maxV += if @property_type.integer then 1 else 0.1

      delta = maxV - minV
      @intervalsLimits = [minV]
      if @property_type.year
        curYear = new Date().getFullYear()
        for yearI in [(Math.max(curYear-10)+1)..curYear]
          @intervalsLimits.push(yearI)

      else if delta <= 2*FacetingHandler.NUM_INTERVALS and not isSmallFloat
        if not @property_type.integer
          minV = Math.floor(minV)
          maxV = Math.ceil(maxV)
        for numJ in [(minV+1)..(maxV)]
          @intervalsLimits.push(numJ)
      else if not isNormalDistributed
        for keyI in _.keys(percentiles)
          if keyI in ['1.0','99.0']
            continue
          nextLimit = percentiles[keyI]
          notIncludeDecimals = @property_type.integer or Math.abs(nextLimit) > 10
          nextLimit *= 100.00 unless notIncludeDecimals
          nextLimit = Math.round(nextLimit)
          nextLimit /= 100.00 unless notIncludeDecimals
          if nextLimit > _.last(@intervalsLimits)
            @intervalsLimits.push(nextLimit)
      else
        lowP = percentiles['1.0']
        hiP = percentiles['99.0']
        lowerBound = Math.round(Math.max(lowP, minV, stats.avg-2.5*stats.std_deviation))
        upperBound = Math.round(Math.min(hiP, maxV, stats.avg+2.5*stats.std_deviation))
        intervalsSize = (upperBound/(FacetingHandler.NUM_INTERVALS-2))-(lowerBound/(FacetingHandler.NUM_INTERVALS-2))
        notIncludeDecimals = @property_type.integer or Math.abs(intervalsSize) > 3
        intervalsSize = glados.Utils.roundNumber(intervalsSize, isSmallFloat, true)


        if intervalsSize == 0
          intervalsSize = 1
        lowerBound *= 100.00 unless notIncludeDecimals
        upperBound *= 100.00 unless notIncludeDecimals
        lowerBound = Math.floor(lowerBound/intervalsSize) * intervalsSize
        upperBound = Math.floor(upperBound/intervalsSize) * intervalsSize
        lowerBound /= 100.00 unless notIncludeDecimals
        upperBound /= 100.00 unless notIncludeDecimals

        curNum = lowerBound
        while curNum <= upperBound and curNum <= maxV
          if curNum > _.last(@intervalsLimits)
            @intervalsLimits.push curNum
          curNum += intervalsSize
        if upperBound < maxV
          @intervalsLimits.push maxV
      if maxV < _.last(@intervalsLimits)
        @intervalsLimits[@intervalsLimits.length - 1] = maxV
      else if maxV > _.last(@intervalsLimits)
        @intervalsLimits.push(maxV)

      if @intervalsLimits.length <= FacetingHandler.NUM_INTERVALS/2
        nextIntervalSet = []
        intervalsLeft = FacetingHandler.NUM_INTERVALS-@intervalsLimits.length
        for valI, i in @intervalsLimits
          nextIntervalSet.push(valI)
          nextI = i + 1
          if nextI < @intervalsLimits.length
            nextVal = @intervalsLimits[nextI]
            if nextVal - valI >= 2
              for newVal in [(valI+1)..(nextVal-1)]
                if intervalsLeft <= 0
                  break
                nextIntervalSet.push(newVal)
                intervalsLeft -= 1
        @intervalsLimits = nextIntervalSet

    parseESResults: (es_aggregations_data, first_call)->

      if first_call
        @faceting_keys_inorder = []
        @faceting_data = {}
      if @faceting_type == FacetingHandler.CATEGORY_FACETING
        aggregated_data = es_aggregations_data[@es_property_name]
        if aggregated_data
          if not _.isUndefined(aggregated_data.buckets)
            for bucket_i in aggregated_data.buckets
              fKey = bucket_i.key
              @parseCategoricalKey(fKey)
              @faceting_data[fKey] = {
                index: @faceting_keys_inorder.length
                count: bucket_i.doc_count
                selected: false
                key_for_humans: @parseCategoricalKey(fKey)
              }
              @faceting_keys_inorder.push(bucket_i.key)

          if not _.isUndefined(aggregated_data.sum_other_doc_count) and aggregated_data.sum_other_doc_count > 0
              @faceting_data[FacetingHandler.OTHERS_CATEGORY] = {
                index: @faceting_keys_inorder.length
                count: aggregated_data.sum_other_doc_count
                selected: false
                key_for_humans: FacetingHandler.OTHERS_CATEGORY
              }
              @faceting_keys_inorder.push(FacetingHandler.OTHERS_CATEGORY)
      else if @faceting_type == FacetingHandler.INTERVAL_FACETING
        if first_call
          stats = es_aggregations_data[@es_property_name+'_STATS']
          percentiles = es_aggregations_data[@es_property_name+'_PERCENTILES'][@es_property_name+'_PERCENTILES'].values
          @calculateIntervals stats, percentiles
        else
          if not @intervalsLimits?
            throw "ERROR! The intervals have not been calculated yet!"
          aggregated_data = es_aggregations_data[@es_property_name]
          if aggregated_data?
            if aggregated_data.buckets
              for bucket_i in aggregated_data.buckets
                fKey = @getIntervalKey(bucket_i)
                @faceting_data[fKey] = {
                  min: bucket_i.from
                  max: bucket_i.to
                  index: @faceting_keys_inorder.length
                  count: bucket_i.doc_count
                  selected: false
                  key_for_humans: fKey
                }
                @faceting_keys_inorder.push(fKey)
              if @property_type.year
                @faceting_keys_inorder.reverse()

      if @sort? and @sort == 'asc'
        @faceting_keys_inorder.sort()
      else if @sort? and @sort == 'desc'
        @faceting_keys_inorder.sort()
        @faceting_keys_inorder.reverse()

    parseCategoricalKey: (key) ->

      esIndex = @es_index
      propName = @es_property_name

      return glados.models.visualisation.PropertiesFactory.parseValueForEntity(esIndex, propName, key)

    getIntervalKey: (bucket_data) ->
      formatKey = if @isYear then ((n)-> return n) else glados.Utils.getFormattedNumber
      if bucket_data.to-bucket_data.from == 1 and @property_type.integer
        return formatKey(bucket_data.from)
      else
        toStr = formatKey(bucket_data.to)+')'
        if @property_type.integer
          toStr = formatKey(bucket_data.to-1)+']'
        return '['+formatKey(bucket_data.from) + '  to  ' + toStr

    needsSecondRequest:()->
      return @faceting_type == FacetingHandler.INTERVAL_FACETING

    # ------------------------------------------------------------------------------------------------------------------
    # Facets Functions
    # ------------------------------------------------------------------------------------------------------------------

    clearFacets: ()->
      @faceting_keys_inorder = []
      @faceting_data = {}

    hasSelection: ()->
      if @faceting_data
        for facet_key, facet_data of @faceting_data
          if facet_data.selected
            return true
      return false

    getSelectedFacetsKeys: ->

      selectedKeys = []

      if @faceting_data
        for facet_key, facet_data of @faceting_data
          if facet_data.selected
            selectedKeys.push facet_key

      return selectedKeys

    getSelectedFacetsFilterQuery: ()->
      selected_query = {
        bool:{ should:[] }
      }
      for facet_key, facet_data of @faceting_data
        if facet_data.selected
          selected_query.bool.should.push(@getFilterQueryForFacetKey(facet_key))
      if selected_query.bool.should.length ==0
        return null
      return selected_query

    toggleKeySelection: (facet_key)->
      @faceting_data[facet_key].selected = not @faceting_data[facet_key].selected
      return @faceting_data[facet_key].selected

    clearSelections: ->
      for fKey, fData of @faceting_data
        fData.selected = false

    getFacetingHandlerId: ()->
      return (@es_index+"_"+@es_property_name).replace(FacetingHandler.KEY_REGEX_REPLACE,"__")

    getFacetId:(facet_key)->
      return (@es_property_name+"_facet_"+@faceting_data[facet_key].index)\
        .replace(FacetingHandler.KEY_REGEX_REPLACE,"__")

    getFilterQueryForFacetKey: (facet_key)->
      filter_terms_query = null
      if @faceting_type == FacetingHandler.CATEGORY_FACETING
        if facet_key == FacetingHandler.OTHERS_CATEGORY
          # For the others query we need to negate the non other category facet keys
          filter_terms_query = {
            bool:{ must_not:[] }
          }
          for facet_key_i in @faceting_keys_inorder
            if facet_key_i != FacetingHandler.OTHERS_CATEGORY
              filter_terms_query.bool.must_not.push(@getFilterQueryForFacetKey(facet_key_i))
        else if facet_key == FacetingHandler.EMPTY_CATEGORY
          filter_terms_query = {
              bool:
                must_not:
                  exists:
                    field: @es_property_name
            }
        else
          filter_terms_query = {term: {}}
          if @js_type == Boolean
            facet_key = parseInt(facet_key)
            facet_key = facet_key == 1
          filter_terms_query.term[@es_property_name] = facet_key
      else if @faceting_type == FacetingHandler.INTERVAL_FACETING
        filter_terms_query = {range: {}}
        filter_terms_query.range[@es_property_name] = {
          'gte': @faceting_data[facet_key].min
          'lt': @faceting_data[facet_key].max
        }

      return filter_terms_query
