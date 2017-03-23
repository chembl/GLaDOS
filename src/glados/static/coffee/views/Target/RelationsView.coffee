# View that renders the Target relations section
# from the target report card
# load CardView first!
RelationsView = CardView.extend

  initialize: ->
    @collection.on 'reset', @.render, @
    @resource_type = 'Target'
    @paginatedView = glados.views.PaginatedViews.PaginatedView.getNewTablePaginatedView(@collection, @el)

    @initEmbedModal('relations')
    @activateModals()

  render: ->

    if @collection.size() == 0 and !@collection.getMeta('force_show')
      $('#TargetRelations').hide()
      return

    @showCardContent()
