# this view is in charge of handling the menu bar that appears on top of the results
glados.useNameSpace 'glados.views.SearchResults',
  ResultsSectionMenuViewView: Backbone.View.extend

    initialize: ->
      @collection.on 'reset do-repaint sort', @render, @

    render: ->

      console.log 'render!'