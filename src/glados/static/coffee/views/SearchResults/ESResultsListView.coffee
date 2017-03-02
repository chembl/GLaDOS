glados.useNameSpace 'glados.views.SearchResults',
  ESResultsListView: Backbone.View.extend(PaginatedViewExt).extend

    initialize: ->
      @collection.on 'reset do-repaint sort', @render, @
      # The before_fetch trigger has only been defined in ESPaginatedQueryCollection
#      @collection.on 'before_fetch_elastic', @showPreloaderHideOthers, @

    render: ->
      @hideHeaderContainer()
      @clearContentContainer()
      @fillTemplates()
      @fillPaginators()
      @activateSelectors()
      @showPaginatedViewContent()

    # not necessary to do anything here
    wakeUpView: ->
