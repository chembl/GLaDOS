# View that renders the drug browser as a paginated table.
DrugBrowserTableView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @

  render: ->
    @clearContentContainer()
    @fillTemplates()
    @fillPaginators()
    @fillPageSelectors()
    @activateSelectors()
    @showContent()