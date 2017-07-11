# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsCompoundMatrixView: Backbone.View.extend

    initialize: ->

      @collection.on 'reset do-repaint', @fetchInfoForMatrix, @

      @MAX_COMPOUNDS_FOR_MATRIX = 10000
      @ctm = new glados.models.Activity.ActivityAggregationMatrix()

      @ctmView = new MatrixView
        model: @ctm
        el: $(@el).find('.BCK-CompTargetMatrix')

      # I need to make the collection load all items
      @fetchInfoForMatrix()

    fetchInfoForMatrix: ->

      @ctmView.clearVisualisation()

      $progressElement = $($(@el).find('.load-messages-container'))
      deferreds = @collection.getAllResults($progressElement, askingForOnlySelected=true)

      thisView = @
      $.when.apply($, deferreds).done( () ->

        # here the data has not been actually received, if this causes more trouble it needs to be investigated.
        if not thisView.collection?
          return

        if thisView.collection.selectedResults.length > thisView.MAX_COMPOUNDS_FOR_MATRIX
          thisView.ctmView.renderWhenError()
          if $progressElement?
            $progressElement.html Handlebars.compile( $('#Handlebars-Common-CollectionErrorMsg').html() )
              msg: 'Too much data to show! Please select some compounds first.'
          return

        #with all items loaded now I can generate the matrix
        moleculeIDs = (item.molecule_chembl_id for item in thisView.collection.selectedResults)
        thisView.ctm.set('chembl_ids', moleculeIDs, {silent:true} )
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

      # I should check later if selection has changed or not.
      @fetchInfoForMatrix()


    sleepView: ->
      
      @ctmView.destroyAllTooltips()


