glados.useNameSpace 'glados.models.paginatedCollections',

  FacetGroupVisibilityHandler: Backbone.Model.extend

    setShowHideFGroupStatus: (identifier, show) -> @get('all_facets_groups')[identifier].show = show

    setShowHideAllFGroupStatus: (show) ->

      allFGroups = @get('all_facets_groups')
      for key, fGroup of allFGroups
        fGroup.show = show