# View that renders the Target Components section
# from the target report card
# load CardView first!
# also make sure the html can access the handlebars templates!
TargetComponentsView = CardView.extend(DownloadViewExt).extend

  initialize: ->

    CardView.prototype.initialize.call(@, arguments)
    @collection.on 'reset', @.render, @
    @resource_type = 'Target'
    @paginatedView = glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView(
      @collection, @el, customRenderEvent=undefined, disableColumnsSelection=true)

    @initEmbedModal('components', arguments[0].target_chembl_id)
    @activateModals()


  events: ->
    return _.extend {}, DownloadViewExt.events

  render: ->

    if @collection.size() == 0 and !@collection.getMeta('force_show')
      return

    @showSection()
    @showCardContent()

  # -----------------------------------------------------------------
  # ---- Downloads
  # -----------------------------------------------------------------
  downloadParserFunction: (attributes) ->

    return attributes.target_components

  getFilename: (format) ->

    if format == 'csv'
      return 'TargetComponents.csv'
    else if format == 'json'
      return 'TargetComponents.json'
    else if format == 'xlsx'
      return 'TargetComponents.xlsx'
    else
      return 'file.txt'