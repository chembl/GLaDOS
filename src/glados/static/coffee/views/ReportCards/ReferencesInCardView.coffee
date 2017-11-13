glados.useNameSpace 'glados.views.ReportCards',
  ReferencesInCardView: CardView.extend

    initialize: ->
      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @render, @

    render: ->
      @showSection()