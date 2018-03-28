glados.useNameSpace 'glados.models.paginatedCollections',

  PaginatedCollectionBase: Backbone.Collection.extend

    initialize: ->

      if @islinkToAllActivitiesEnabled()
        console.log 'LINK TO ALL ACTIVITIES ENABLED'
#        @on glados.Events.Collections.SELECTION_UPDATED,

    islinkToAllActivitiesEnabled: -> @getMeta('enable_activities_link_for_selected_entities') == true

    # ------------------------------------------------------------------------------------------------------------------
    # Link to all activities
    # ------------------------------------------------------------------------------------------------------------------
    resetLinkToAllActivities: -> @setMeta('enable_activities_link_for_selected_entities', undefined)

