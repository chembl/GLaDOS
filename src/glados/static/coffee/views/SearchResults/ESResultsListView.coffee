glados.useNameSpace 'glados.views.SearchResults',
  ESResultsListView: Backbone.View.extend(PaginatedViewExt).extend

    initialize: ->
      @collection.on 'reset do-repaint sort', @.render, @

    render: ->
      @hideHeaderContainer()
      @clearContentContainer()
      @fillTemplates()
      @fillPaginators()
      @activateSelectors()
      @showPaginatedViewContent()