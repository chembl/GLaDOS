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

    slider = document.getElementById('search_max_phase')

    if $(slider).attr('initialised') == 'yes'
      # ahhhh! >(
      return

    noUiSlider.create slider,
      start: [
        20
        80
      ]
      connect: true
      start: [0, 4]
      step: 1
      range:
        'min': 0
        'max': 4
      format: wNumb(decimals: 0)

    slider.noUiSlider.on 'update', @setNumericSearchWrapper($(slider))
    $(slider).attr('initialised', 'yes')