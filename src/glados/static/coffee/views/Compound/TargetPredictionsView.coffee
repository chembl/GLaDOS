glados.useNameSpace 'glados.views.Compound',
  TargetPredictionsView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @.render, @
      @model.on 'error', @.showCompoundErrorCard, @
      @resource_type = 'Compound'


    render: ->

      console.log 'RENDER TARG PREDS!'
      rawTargetPredidctions = @model.get('_metadata').target_predictions
      if not rawTargetPredidctions?
        return
      if rawTargetPredidctions.length == 0
        return

      console.log 'targ preds!', @model.get('_metadata').target_predictions

      @showSection()