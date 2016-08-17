DrugBrowserInfinityView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @isInfinte = true
    $(@el).find('select').material_select();


  render: ->

    @fill_template('DrugInfBrowserCardsContainer')
    @hideInfiniteBrPreolader()

    @setUpLoadingWaypoint()



