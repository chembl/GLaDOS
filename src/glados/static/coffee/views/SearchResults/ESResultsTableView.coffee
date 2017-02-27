glados.useNameSpace 'glados.views.SearchResults',
  ESResultsTableView: Backbone.View.extend(PaginatedViewExt).extend

    initialize: ->

      @collection.on 'reset do-repaint sort', @render, @
      # The before_fetch trigger has only been defined in ESPaginatedQueryCollection
      @collection.on 'before_fetch_elastic', @showPreloaderHideOthers, @

      @render()

    render: ->

      @clearContentContainer()
      @fillTemplates()
      @fillPaginators()
      @fillPageSelectors()
      @activateSelectors()
      @showPaginatedViewContent()

    # not necessary to do anything here
    wakeUpView: ->