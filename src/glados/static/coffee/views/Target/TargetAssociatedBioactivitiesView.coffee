TargetAssociatedBioactivitiesView = CardView.extend

  initialize: ->

    @model.on 'change', @render, @
    @resource_type = 'Target'
    @paginatedView = new PieView
      model: @model
      el: $(@el).find('.BCK-Main-Pie-container')

    @initEmbedModal('bioactivities')
    @activateModals()

  render: -> @showCardContent()
