glados.useNameSpace 'glados.models.paginatedCollections.StateSaving',

  ESCollectionStateSavingFunctions:

    # Keep in mind that the state object needs to ALWAYS be serializable, because it will be included in urls and
    # transferred externally
    getStateJSON: ->

      propertiesToSave = ['settings_path', 'custom_query_string', 'use_custom_query_string', 'sticky_query',
        'esSearchQuery', 'search_term', 'contextual_properties', 'generator_items_list']

      state = {}
      for prop in propertiesToSave
        value = @getMeta(prop)
        state[prop] = value

      #now add a serializable structure for the facets
      includeFacetsState = false
      facetGroups = @getFacetsGroups()
      facetsState = {
        selected: {}
      }

      for facetGroupKey, fGroup of facetGroups

        facetingHandler = fGroup.faceting_handler
        hasSelection = facetingHandler.hasSelection()
        if not hasSelection
          continue

        facetsState.selected[facetGroupKey] = facetingHandler.getSelectedFacetsKeys()
        includeFacetsState = true

      if includeFacetsState
        state.facets_state =  facetsState

      return state


