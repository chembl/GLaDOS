# View that renders the drug browser as a paginated table.
DrugBrowserTableView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @

  render: ->
    console.log('render!')
    @clearTable()
    @fill_template('DBTable-large')
    @fillPaginator('DB-paginator')

    @activatePageSelector()
    @showVisibleContent()


  clearTable: ->

    $('#DBTable-large').empty()

  showVisibleContent: ->
    $(@el).find('#DB-MainContent').children('.card-preolader-to-hide').hide()
    $(@el).find('#DB-MainContent').children(':not(.card-preolader-to-hide, .card-load-error, .modal)').show()

  showPreloader: ->
    $(@el).find('#DB-MainContent').children('.card-preolader-to-hide').show()
    $(@el).find('#DB-MainContent').children(':not(.card-preolader-to-hide)').hide()