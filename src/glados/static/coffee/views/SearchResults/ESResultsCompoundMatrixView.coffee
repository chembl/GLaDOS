# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsCompoundMatrixView: Backbone.View.extend

    initialize: ->

      console.log 'INITIALIZING MATRIX!'