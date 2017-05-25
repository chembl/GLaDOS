TargetAssociatedBioactivitiesView = CardView.extend

  initialize: ->

    @resource_type = 'Target'
    @initEmbedModal('bioactivities')
    @activateModals()
    console.log 'INITIALISED!'

  render: ->
    console.log 'RENDERED!'
    @showCardContent()
