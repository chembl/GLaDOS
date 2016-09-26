# View that renders a list of resulting documents as paginated cards.
DocumentResultsListView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @$preloaderContainer = $('#BCK-DocsPreoladerContainer')
    @$contentContainer = $('#BCK-DocsCardsPageContainer')

  render: ->
    @clearCardsPage()
    @fillTemplates('BCK-DocsCardsPageContainer')
    @fillPaginators()
    @fillPageSelectors()
    @renderSortingSelector()
    @activateSelectors()
    @showVisibleContent()