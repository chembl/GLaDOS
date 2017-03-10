glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Faceting Handler
  # --------------------------------------------------------------------------------------------------------------------
  FacetingHandler: class FacetingHandler
    @CATEGORY_FACETING = 'CATEGORY'
    @INTERVAL_FACETING = 'INTERVAL'

    @OTHERS_CATEGORY = 'Others'
    @KEY_REGEX_REPLACE = /[^A-Z0-9]/gi

    @getNewFacetingHandler = (es_index, es_property)->
      es_index_schema =  glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema[es_index]
      if not es_index_schema
        console.log("ERROR! unknown elastic index "+es_index)
      property_type = es_index_schema[es_property]
      if not property_type
        console.log("ERROR! unknown "+es_property+" for elastic index "+es_index)
      if not property_type.aggregatable
        console.log("ERROR! "+es_property+" for elastic index "+es_index+" is not aggregatable")
      if property_type.type == String or property_type.type == Boolean
        return new FacetingHandler(es_property, property_type.type, FacetingHandler.CATEGORY_FACETING)
      else if property_type.type == Number
        return new FacetingHandler(es_property, property_type.type, FacetingHandler.INTERVAL_FACETING)
      else
        console.log("ERROR! "+es_property+" for elastic index "+es_index+" with type "+property_type.type\
            +" does not have a defined faceting type")

    constructor:(@es_property_name, @js_type, @faceting_type)->
      @faceting_keys_inorder = null
      @faceting_data = null

    addQueryAggs:(es_query_aggs)->
      if @faceting_type == FacetingHandler.CATEGORY_FACETING
        es_query_aggs[@es_property_name] = {
          terms:
            field: @es_property_name
        }

    parseESResults: (es_aggregations_data)->
      @faceting_keys_inorder = []
      @faceting_data = {}
      if @faceting_type == FacetingHandler.CATEGORY_FACETING
        aggregated_data = es_aggregations_data[@es_property_name]
        if aggregated_data
          if not _.isUndefined(aggregated_data.buckets)
            for bucket_i in aggregated_data.buckets
              @faceting_keys_inorder.push(bucket_i.key)
              @faceting_data[bucket_i.key] = bucket_i.doc_count

          if not _.isUndefined(aggregated_data.sum_other_doc_count) and aggregated_data.sum_other_doc_count > 0
              @faceting_keys_inorder.push(FacetingHandler.OTHERS_CATEGORY)
              @faceting_data[FacetingHandler.OTHERS_CATEGORY] = aggregated_data.sum_other_doc_count

    getFacetId:(key_i)->
      return @es_property_name+"_"+key_i.replace(FacetingHandler.KEY_REGEX_REPLACE,'_')

    getFilterQueryForFacetIndex: (facet_index)->
      filter_terms_query = null
      if @faceting_type == FacetingHandler.CATEGORY_FACETING
        facet_key = @faceting_keys_inorder[facet_index]
        if facet_key != FacetingHandler.OTHERS_CATEGORY
          filter_terms_query = {term: {}}
          filter_terms_query.term[@es_property_name] = facet_key
        else
          # For the others query we need to negate the non other category facet keys
          filter_terms_query = {
            not:[]
          }
          for facet_key_i in @faceting_keys_inorder
            if facet_key_i != FacetingHandler.OTHERS_CATEGORY
              key_i_term_query = {term: {}}
              key_i_term_query.term[@es_property_name] = facet_key_i
              filter_terms_query.not.push(key_i_term_query)
      console.log filter_terms_query
      return filter_terms_query
