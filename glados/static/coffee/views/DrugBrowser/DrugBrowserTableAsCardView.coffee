# View that renders the drug browser as a paginated table.
DrugBrowserTableAsCardView = CardView.extend(PaginatedViewExt).extend

  #TODO: USE EMBEDABILITY!

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @

  render: ->
    @clearContentContainer()
    @fillTemplates()
    @fillPaginators()
    @fillPageSelectors()
    @activateSelectors()
    @showContent()