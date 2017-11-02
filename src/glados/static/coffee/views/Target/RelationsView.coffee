# View that renders the Target relations section
# from the target report card
# load CardView first!
RelationsView = CardView.extend

  initialize: ->
    @collection.on 'reset', @.render, @
    @resource_type = 'Target'
    @paginatedView = glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView(
      @collection, @el,customRenderEvent=undefined, disableColumnsSelection=true)

    @initEmbedModal('relations', arguments[0].target_chembl_id)
    @activateModals()

  render: ->

    if @collection.size() == 0 and !@collection.getMeta('force_show')
      $('#TargetRelations').hide()
      return

    @showCardContent()
