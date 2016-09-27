# View that renders a list of resulting documents as paginated cards.
DocumentResultsListView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @

  render: ->
    @clearContentContainer()
    @fillTemplates()
    @fillPaginators()
    @fillPageSelectors()
    @renderSortingSelector()
    @activateSelectors()
    @showContent()