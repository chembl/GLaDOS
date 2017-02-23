# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsCompoundMatrixView: Backbone.View.extend

    initialize: ->

      console.log 'INITIALIZING MATRIX!'
      # I need to make the collection load all items
      $progressElement = $($(@el).find('.load-messages-container'))
      deferreds = @collection.getAllResults($progressElement)

      thisView = @
      $.when.apply($, deferreds).done( () ->
        #with all items loaded now I can generate the matrix

        ctm = new CompoundTargetMatrix
        ctm.set('molecule_chembl_ids', (item.molecule_chembl_id for item in thisView.collection.allResults) )
        new CompoundTargetMatrixView
          model: ctm
          el: $(thisView.el).find('.BCK-CompTargetMatrix')
          ctm.fetch()

        setTimeout( (()-> $progressElement.html ''), 200)
      )


