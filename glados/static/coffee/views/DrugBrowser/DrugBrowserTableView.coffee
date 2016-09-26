# View that renders the drug browser as a paginated table.
DrugBrowserTableView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @$preloaderContainer = $('#DB-MainContent')
    @$contentContainer = @$preloaderContainer

  render: ->
    @clearTable()
    @fillTemplates('DBTable-large')
    @fillPaginators('DB-paginator')
    @fillPageSelectors()
    @activateSelectors()
    @showVisibleContent()


  clearTable: ->

    $('#DBTable-large').empty()