# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsCompoundMatrixView: Backbone.View.extend

    initialize: ->

      @collection.on 'reset do-repaint', @fetchInfoForMatrix, @

      @ctm = new CompoundTargetMatrix
      @ctmView = new MatrixView
          model: @ctm
          el: $(@el).find('.BCK-CompTargetMatrix')

      # I need to make the collection load all items
      @fetchInfoForMatrix()

    fetchInfoForMatrix: ->

      @ctmView.clearVisualisation()

      $progressElement = $($(@el).find('.load-messages-container'))
      deferreds = @collection.getAllSelectedResults($progressElement)

      thisView = @
      $.when.apply($, deferreds).done( () ->

        # here the data has not been actually received, if this causes more trouble it needs to be investigated.
        if not thisView.collection?
          return
        if not thisView.collection.allResults[0]?
          return

        #with all items loaded now I can generate the matrix
        thisView.ctm.set('molecule_chembl_ids', (item.molecule_chembl_id for item in thisView.collection.allResults), {silent:true} )
        thisView.ctm.fetch()

        setTimeout( (()-> $progressElement.html ''), 200)
      ).fail( (msg) ->

        if $progressElement?
          $progressElement.html Handlebars.compile( $('#Handlebars-Common-CollectionErrorMsg').html() )
            msg: msg

        thisView.ctmView.renderWhenError()
      )

    getVisibleColumns: -> _.union(@collection.getMeta('columns'), @collection.getMeta('additional_columns'))

    wakeUpView: ->

      if @collection.DOWNLOADED_ITEMS_ARE_VALID
        @ctmView.render()
      else
        @fetchInfoForMatrix()


    sleepView: ->
      
      @ctmView.destroyAllTooltips()

