DrugBrowserInfinityView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @isInfinte = true



  render: ->

    @fill_template('DrugInfBrowserCardsContainer')
    @hideInfiniteBrPreolader()

    @setUpLoadingWaypoint()


