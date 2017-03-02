glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Faceting Handler
  # --------------------------------------------------------------------------------------------------------------------
  FacetingHandler: class FacetingHandler
    @CATEGORY_FACETING = 'CATEGORY'

    @OTHERS_CATEGORY = 'Others'

    @getNewCategoryFacetingHandler = (es_property)->
      return new FacetingHandler(es_property, FacetingHandler.CATEGORY_FACETING)

    constructor:(@property, @faceting_type)->
      @faceting_keys_inorder = null
      @faceting_data = null

    addQueryAggs:(es_query_aggs)->
      if @faceting_type == FacetingHandler.CATEGORY_FACETING
        es_query_aggs[@property] = {
          terms:
            field: @property
        }

    parseESResults: (es_aggregations_data)->
      @faceting_keys_inorder = []
      @faceting_data = {}
      if @faceting_type == FacetingHandler.CATEGORY_FACETING
        aggregated_data = es_aggregations_data[@property]
        if aggregated_data
          if not _.isUndefined(aggregated_data.buckets)
            for bucket_i in aggregated_data.buckets
              @faceting_keys_inorder.push(bucket_i.key)
              @faceting_data[bucket_i.key] = bucket_i.doc_count

          if not _.isUndefined(aggregated_data.sum_other_doc_count) and aggregated_data.sum_other_doc_count > 0
              @faceting_keys_inorder.push(FacetingHandler.OTHERS_CATEGORY)
              @faceting_data[FacetingHandler.OTHERS_CATEGORY] = aggregated_data.sum_other_doc_count
          console.log('FACETS!',@faceting_keys_inorder)
          console.log('FACETS!',@faceting_data)

    getQueryFilterTermsForFacetIndex: (facet_index)->
      filter_terms = []
      if @faceting_type == FacetingHandler.CATEGORY_FACETING
        facet_key = @faceting_keys_inorder[facet_index]
        if facet_key != FacetingHandler.OTHERS_CATEGORY
          filter_terms.push('+'+@property+':'+facet_key)
        else
          for key_i in @faceting_keys_inorder
            if key_i != FacetingHandler.OTHERS_CATEGORY
              filter_terms.push('-'+@property+':'+key_i)
      return filter_terms
