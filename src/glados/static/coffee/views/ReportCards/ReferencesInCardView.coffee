glados.useNameSpace 'glados.views.ReportCards',
  ReferencesInCardView: CardView.extend

    initialize: ->
      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @render, @
      new glados.views.References.ReferencesView
        model: @model
        el: $(@el).find('.BCK-ReferencesContainer')

    render: ->
      @showSection()