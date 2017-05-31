TargetAssociatedAssaysView = CardView.extend

  initialize: ->

    @model.on 'change', @render, @
    @resource_type = 'Target'
    @paginatedView = new PieView
      model: @model
      el: @el

    @initEmbedModal('associated_assays')
    @activateModals()

  render: -> @showCardContent()