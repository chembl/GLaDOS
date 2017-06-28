glados.useNameSpace 'glados.views.Target',
  AssociatedCompoundsView: CardView.extend

    initialize: ->
      @showCardContent()

      @resource_type = 'Target'
      @initEmbedModal('associated_compounds')
      @activateModals()

      @histogramView = new glados.views.Visualisation.HistogramView
        el: $(@el).find('.BCK-MainHistogramContainer')