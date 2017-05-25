TargetAssociatedBioactivitiesView = CardView.extend

  initialize: ->

    @resource_type = 'Target'
    @paginatedView = new PieView
      el: @el
    @paginatedView.render()
    @initEmbedModal('bioactivities')
    @activateModals()

  render: -> @showCardContent()
