DrugBrowserInfinityView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'sync', @.render, @
    @isInfinite = true
    @containerID = 'DrugInfBrowserCardsContainer'

  render: ->

    @renderSortingSelector()
    @showControls()
    $(@el).find('select').material_select();
    @fill_template(@containerID)
    @fillNumResults()
    @hideInfiniteBrPreolader()
    @setUpLoadingWaypoint()
