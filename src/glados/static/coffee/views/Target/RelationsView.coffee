# View that renders the Target relations section
# from the target report card
# load CardView first!
RelationsView = CardView.extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @resource_type = 'Target'
    @paginatedView = PaginatedView.getNewTablePaginatedView(@collection, @el)

  render: ->

    if @collection.size() == 0 and !@collection.getMeta('force_show')
      $('#TargetRelations').hide()
      return

    @showCardContent()
    @initEmbedModal('relations')
    @activateModals()
