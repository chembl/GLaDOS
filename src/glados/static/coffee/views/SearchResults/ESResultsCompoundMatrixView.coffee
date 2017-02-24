# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsCompoundMatrixView: Backbone.View.extend

    initialize: ->

      @collection.on 'reset do-repaint', @fetchInfoForMatrix, @

      @ctm = new CompoundTargetMatrix
      @ctmView = new CompoundTargetMatrixView
          model: @ctm
          el: $(@el).find('.BCK-CompTargetMatrix')

      # I need to make the collection load all items
      @fetchInfoForMatrix()

    fetchInfoForMatrix: ->

      @ctmView.clearVisualisation()

      $progressElement = $($(@el).find('.load-messages-container'))
      deferreds = @collection.getAllResults($progressElement)

      thisView = @
      $.when.apply($, deferreds).done( () ->
        #with all items loaded now I can generate the matrix
        thisView.ctm.set('molecule_chembl_ids', (item.molecule_chembl_id for item in thisView.collection.allResults), {silent:true} )
        thisView.ctm.fetch()

        setTimeout( (()-> $progressElement.html ''), 200)
      )


