glados.useNameSpace 'glados.models.paginatedCollections.StateSaving',

  ESCollectionStateSavingFunctions:

    # Keep in mind that the state object needs to ALWAYS be serializable, because it will be included in urls and
    # transferred externally
    getStateJSON: ->

      propertiesToSave = ['settings_path', 'custom_query', 'use_custom_query', 'sticky_query',
        'searchESQuery', 'search_term', 'contextual_properties', 'generator_items_list',
        'at_least_one_facet_is_selected']

      state = {}
      for prop in propertiesToSave
        value = @getMeta(prop)
        state[prop] = value

      #now add a serializable structure for the facets
      includeFacetsState = false
      facetGroups = @getFacetsGroups()
      facetsState = {}

      for facetGroupKey, fGroup of facetGroups

        facetingHandler = fGroup.faceting_handler
        hasSelection = facetingHandler.hasSelection()
        facetsState[facetGroupKey] = facetingHandler.getStateJSON()
        includeFacetsState |= hasSelection

      if includeFacetsState
        state.facets_state = facetsState

      return state


