glados.useNameSpace 'glados.models.paginatedCollections',

  PaginatedCollectionBase: Backbone.Collection.extend

    initialize: ->

      if @islinkToAllActivitiesEnabled()
        @on glados.Events.Collections.SELECTION_UPDATED, @resetLinkToAllActivities, @

    islinkToAllActivitiesEnabled: -> @getMeta('enable_activities_link_for_selected_entities') == true

    # ------------------------------------------------------------------------------------------------------------------
    # Link to all activities
    # ------------------------------------------------------------------------------------------------------------------
    resetLinkToAllActivities: -> @setMeta('all_activities_link_cache', undefined)

