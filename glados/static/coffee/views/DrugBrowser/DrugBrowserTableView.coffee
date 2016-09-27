# View that renders the drug browser as a paginated table.
DrugBrowserTableView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @$preloaderContainer = $('#DB-MainContent')
    @$contentContainer = @$preloaderContainer

  render: ->
    @clearTable()
    @fillTemplates()
    @fillPaginators()
    @fillPageSelectors()
    @activateSelectors()
    @showVisibleContent()


  clearTable: ->

    $('.BCK-items-container').empty()