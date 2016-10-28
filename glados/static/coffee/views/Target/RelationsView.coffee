# View that renders the Target relations section
# from the target report card
# load CardView first!
RelationsView = CardView.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @resource_type = 'Target'

  render: ->

    if @collection.size() == 0 and !@collection.getMeta('force_show')
      $('#TargetRelations').hide()
      return

    @clearContentContainer()

    @fillTemplates()
    @fillPaginators()

    @showCardContent()
    @showContent()
    @initEmbedModal('relations')
    @activateModals()

    @fillPageSelectors()
    @activateSelectors()