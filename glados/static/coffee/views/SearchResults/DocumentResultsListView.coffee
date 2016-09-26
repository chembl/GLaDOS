# View that renders a list of resulting documents as paginated cards.
DocumentResultsListView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @$preloaderContainer = $('#BCK-DocsPreoladerContainer')
    @$contentContainer = $('#BCK-DocsCardsPageContainer')

  render: ->
    @clearCardsPage()
    @fill_template('BCK-DocsCardsPageContainer')
    @fillPaginator('BCK-Docs-Cards-paginator')
    @fillPageSelector()
    @renderSortingSelector()
    @activateSelectors()
    @showVisibleContent()