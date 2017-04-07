# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsGraphView: Backbone.View.extend

    initialize: ->

      @collection.on 'reset do-repaint', @fetchInfoForGraph, @

      @compResGraphView = new PlotView
        el: $(@el).find('.BCK-CompResultsGraph')
        collection: @collection

      @fetchInfoForGraph()

    fetchInfoForGraph: ->

      @compResGraphView.clearVisualisation()

      $progressElement = $($(@el).find('.load-messages-container'))
      deferreds = @collection.getAllResults($progressElement)

      thisView = @
      #REMINDER, THIS COULD BE A NEW EVENT, it could help for future cases.
      $.when.apply($, deferreds).done( () ->

        if !thisView.collection.allResults[0]?
          # here the data has not been actually received, if this causes more trouble it needs to be investigated.
          return

        $progressElement.html ''
        thisView.compResGraphView.render()
      ).fail( (msg) ->

        if $progressElement?
          $progressElement.html Handlebars.compile( $('#Handlebars-Common-CollectionErrorMsg').html() )
            msg: msg

        thisView.compResGraphView.renderWhenError()
      )

    getVisibleColumns: -> _.union(@collection.getMeta('columns'), @collection.getMeta('additional_columns'))

    wakeUpView: ->

      if @collection.DOWNLOADED_ITEMS_ARE_VALID
        @compResGraphView.render()
      else
        @fetchInfoForGraph()