# View that renders a list of resulting compounds as paginated cards.
CompoundResultsListView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @

  render: ->
    @clearContentContainer()
    @fillTemplates()
    @fillPaginators()
    @fillPageSelectors()
    @renderSortingSelector()
    @activateSelectors()
    @showPaginatedViewContent()
