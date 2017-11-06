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

    @NUM_INTERVALS: 10

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

    @generateFacetsForIndex: (es_index, defaults, defaults_hidden, exclude_patterns)->
      facets = {}
      if not _.has(glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema, es_index)
        throw 'ERROR: '+es_index+' was not found in the Generated Schema for GLaDOS!'
      gs_data = glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema[es_index]
      cur_pos = 1
      getFacetData = (prop_name)->
        if prop_name not in _.keys(gs_data)
          throw 'ERROR: '+prop_name+' is not a property of '+es_index+'!'
        if gs_data[prop_name].aggregatable
          return {
            label: django.gettext(gs_data[prop_name].label_id)
            label_mini: django.gettext(gs_data[prop_name].label_mini_id)
            show: false
            position: cur_pos++
            faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
              es_index, prop_name
            )
          }
        throw 'ERROR: '+prop_name+' is not an aggregatable property!'
      all_props = _.filter(_.keys(gs_data), (property_name)->
        if not gs_data[property_name].aggregatable
          return false
        if exclude_patterns?
          for exclude_pattern_i in exclude_patterns
            exclude = exclude_pattern_i.test(property_name)
            if exclude
              return false
        return true
      )
      if defaults?
        for prop_i in defaults
          facets[prop_i] = getFacetData(prop_i)
          facets[prop_i].show = true
      if defaults_hidden?
        for prop_i in defaults_hidden
          facets[prop_i] = getFacetData(prop_i)
          facets[prop_i].show = false
      return facets

    @getNewFacetingHandler: (es_index, es_property)->
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
          property_type
        )
      else if property_type.type == Number
        return new FacetingHandler(
          es_index,
          es_property,
          property_type.type,
          FacetingHandler.INTERVAL_FACETING,
          property_type, property_type.year
        )
      else
        throw "ERROR! "+es_property+" for elastic index "+es_index+" with type "+property_type.type\
            +" does not have a defined faceting type"

    # ------------------------------------------------------------------------------------------------------------------
    # Instance Context
    # ------------------------------------------------------------------------------------------------------------------

    constructor: (@es_index, @es_property_name, @js_type, @faceting_type, @property_type, @isYear)->
      @faceting_keys_inorder = null
      @faceting_data = null
      @intervalsLimits

    # ------------------------------------------------------------------------------------------------------------------
    # Query and Parse Facets to/from Elasticsearch
    # ------------------------------------------------------------------------------------------------------------------

    # Interval aggregations require 2 calls to find out first the min/max/dev_std range
    # and then create an histogram of n columns
    addQueryAggs: (es_query_aggs, first_call)->
      if @faceting_type == FacetingHandler.CATEGORY_FACETING
        if first_call
          es_query_aggs[@es_property_name] = {
            terms:
              field: @es_property_name
          }
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
            percentiles:
              field: @es_property_name,
              percents: [10,20,30,40,50,60,70,80,90],
              keyed: true
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

      isSmallFloat = intervalsSize < 5 and not @property_type.integer
      isNormalDistributed = percentiles['80.0'] > stats.avg or percentiles['20.0'] < stats.avg

      roundedMin = glados.Utils.roundNumber(stats.min, isSmallFloat, true)
      roundedMax = glados.Utils.roundNumber(stats.max, isSmallFloat)

      @intervalsLimits = [roundedMin]

      if stats.max - stats.min <= FacetingHandler.NUM_INTERVALS and @property_type.integer
        for numJ in [roundedMin+1..roundedMax-1]
          @intervalsLimits.push(numJ)
      if not isNormalDistributed
        for keyI in _.keys(percentiles)
          @intervalsLimits.push glados.Utils.roundNumber(percentiles[keyI], true)
      else
        lowerBound = glados.Utils.roundNumber(stats.avg - 2 * stats.std_deviation)
        upperBound = glados.Utils.roundNumber( stats.avg + 2 * stats.std_deviation)
        intervalsSize = (upperBound/FacetingHandler.NUM_INTERVALS)-(lowerBound/FacetingHandler.NUM_INTERVALS)
        intervalsSize = glados.Utils.roundNumber(intervalsSize, isSmallFloat)
        curNum = lowerBound
        while curNum < upperBound and curNum < roundedMax
          if curNum > @intervalsLimits[-1]
            @intervalsLimits.push curNum
          curNum += intervalsSize
        if upperBound < roundedMax
          @intervalsLimits.push roundedMax

      @intervalsLimits.push(roundedMax)
      console.warn(@property_type, @intervalsLimits, isNormalDistributed)


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
          percentiles = es_aggregations_data[@es_property_name+'_PERCENTILES'].values
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
                  max: bucket_i.from + bucket_i.to
                  index: @faceting_keys_inorder.length
                  count: bucket_i.doc_count
                  selected: false
                  key_for_humans: fKey
                }
                @faceting_keys_inorder.push(fKey)

    parseCategoricalKey: (key) ->

      esIndex = @es_index
      propName = @es_property_name

      return glados.models.visualisation.PropertiesFactory.parseValueForEntity(esIndex, propName, key)

    getIntervalKey: (bucket_data) ->
      formatKey = if @isYear then ((n)-> return n) else glados.Utils.getFormattedNumber
      if @intervals_size == 1
        return formatKey(bucket_data.from)
      else
        return formatKey(bucket_data.from) + "  to  " + formatKey(bucket_data.to)

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
          filter_terms_query.term[@es_property_name] = facet_key
      else if @faceting_type == FacetingHandler.INTERVAL_FACETING
        filter_terms_query = {range: {}}
        filter_terms_query.range[@es_property_name] = {
          'gte': @faceting_data[facet_key].min
          'lt': @faceting_data[facet_key].max
        }

      return filter_terms_query
