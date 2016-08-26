DrugBrowserInfinityView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'sync', @.render, @
    @isInfinite = true
    @containerID = 'DrugInfBrowserCardsContainer'

  render: ->

    console.log 'num items in collection: ', @collection.models.length
    console.log 'items: ', _.map(@collection.models, (item) -> item.get('molecule_chembl_id'))

    @renderSortingSelector()
    @showControls()
    $(@el).find('select').material_select();
    @fill_template(@containerID)
    @fillNumResults()
    @hideInfiniteBrPreolader()
    @setUpLoadingWaypoint()

    console.log 'num cards: ', $('#DrugInfBrowserCardsContainer').children().length