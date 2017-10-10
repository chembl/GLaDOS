glados.useNameSpace 'glados.models.paginatedCollections',

  FacetGroupVisibilityHandler: Backbone.Model.extend

    setShowHideFGroupStatus: (identifier, show) ->

      allFGroups = @get('all_facets_groups')
      allFGroups[identifier].show = show
