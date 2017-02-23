# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsCompoundMatrixView: Backbone.View.extend

    initialize: ->

      console.log 'INITIALIZING MATRIX!'
      # I need to make the collection load all items
      
      ctm = new CompoundTargetMatrix
      new CompoundTargetMatrixView
        model: ctm
        el: $('#CompTargetMatrix')

      ctm.fetch()