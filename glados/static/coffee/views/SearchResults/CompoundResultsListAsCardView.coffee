# View that renders a list of resulting compounds as paginated cards, inserted inside a card
CompoundResultsListAsCardView = CardView.extend(PaginatedViewExt).extend

  #TODO: USE EMBEDABILITY!

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