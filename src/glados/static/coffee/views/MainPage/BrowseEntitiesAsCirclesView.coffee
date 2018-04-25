glados.useNameSpace 'glados.views.MainPage',
  BrowseEntitiesAsCirclesView: Backbone.View.extend

    initialize: ->
      console.log "I'm initializing this View :)"
      @render()

    render: ->
      console.log 'AAAAND I will render it!!! :)'
