# View that renders the Molecule Features section
# from the compound report card
CompoundFeaturesView = CardView.extend

   initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @

   render: ->
     # until here, all the visible content has been rendered.
     $(@el).children('.card-preolader-to-hide').hide()
     $(@el).children(':not(.card-preolader-to-hide, .card-load-error)').show()