# View that renders a list of resulting compounds as paginated cards.
CompoundResultsListView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @$preloaderContainer = $('#BCK-CompsPreoladerContainer')
    @$contentContainer = $('#BCK-CompsCardsPageContainer')

  render: ->
    @clearCardsPage()
    @fill_template('BCK-CompsCardsPageContainer')
    @fillPaginator('BCK-Comps-Cards-paginator')
    @fillAndActivatePageSelector()
    @showVisibleContent()
