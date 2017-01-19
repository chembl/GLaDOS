# View that renders the Compound Metabolism Section
CompoundMetabolismView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Compound'

  render: ->

    @showCardContent()
    MetabolismVisualizator._loadFromVariable("metabolism-visualisation-container", @model.get('graph'))

