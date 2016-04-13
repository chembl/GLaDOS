# View that renders the Compound Mechanisms of Action section
# of the compound report card
# load CardView first!
# also make sure the html can access the handlebars templates!
CompoundMechanismsOfActionView = CardView.extend

  initialize: ->
    @collection.on 'reset', @render, @
    @collection.on 'error', @.showCompoundErrorCard, @

  render: ->

    if @collection.size() == 0
      $('#MechanismOfAction').hide()
      return

    @addAllMechanisms()

    # until here, all the visible content has been rendered.
    @showVisibleContent()

    @initEmbedModal('mechanism_of_action')
    @activateTooltips()
    @activateModals()

  addOneMechanism: (mechanismOfAction) ->
    view = new MechanismOfActionRowView({model: mechanismOfAction});
    table = $(@el).find('table')
    table.append(view.render().el)

    collItemView = new MechanismOfActionCollItemView({model:mechanismOfAction})
    coll = $(@el).find('ul')
    coll.append(collItemView.render().el)

  addAllMechanisms: ->
    @collection.forEach @addOneMechanism, @


