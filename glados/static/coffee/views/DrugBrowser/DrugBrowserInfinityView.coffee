DrugBrowserInfinityView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @isInfinte = true

  render: ->

    @renderSortingSelector()
    @showControls()
    $(@el).find('select').material_select();
    @fill_template('DrugInfBrowserCardsContainer')
    @hideInfiniteBrPreolader()

    @setUpLoadingWaypoint()






