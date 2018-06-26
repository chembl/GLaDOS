# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsGraphView: Backbone.View.extend

    initialize: ->

      @config = arguments[0].config
      @config ?= {}
      @collection.on 'reset do-repaint', @fetchInfoForGraph, @

      config = {
        properties:
          molecule_chembl_id: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'CHEMBL_ID')
          ALogP: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'ALogP')
          FULL_MWT: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'FULL_MWT')
          RO5: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5',
            withColourScale = true)
          PSA: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'PSA')
          HBA: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'HBA')
          HBD: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'HBD')
        id_property: 'molecule_chembl_id'
        labeler_property: 'molecule_chembl_id'
        initial_property_x: 'ALogP'
        initial_property_y: 'FULL_MWT'
        initial_property_colour: 'RO5'
        x_axis_options:['ALogP', 'FULL_MWT', 'PSA', 'HBA', 'HBD', 'RO5']
        y_axis_options:['ALogP', 'FULL_MWT', 'PSA', 'HBA', 'HBD', 'RO5']
        colour_options:['RO5', 'FULL_MWT']
        markers_border: PlotView.MAX_COLOUR
      }

      @compResGraphView = new PlotView
        el: $(@el).find('.BCK-MainPlotContainer')
        collection: @collection
        config: config

      @fetchInfoForGraph() unless @config.embedded

    fetchInfoForGraph: ->

      @compResGraphView.clearVisualisation()

      $progressElement = $(@el).find('.load-messages-container')
      deferreds = @collection.getAllResults($progressElement)

      thisView = @
      #REMINDER, THIS COULD BE A NEW EVENT, it could help for future cases.
      $.when.apply($, deferreds).done( () ->

        if !thisView.collection.allResults[0]?
          # here the data has not been actually received, if this causes more trouble it needs to be investigated.
          return

        $progressElement.html ''
        thisView.showPlot()
      ).fail( (msg) ->

        if $progressElement?
          $progressElement.html Handlebars.compile( $('#Handlebars-Common-CollectionErrorMsg').html() )
            msg: msg

        thisView.compResGraphView.renderWhenError()
      )

    getVisibleColumns: -> _.union(@collection.getMeta('columns'), @collection.getMeta('additional_columns'))

    wakeUpView: ->

      @collection.wakeUp()
      if @collection.DOWNLOADED_ITEMS_ARE_VALID
        @showPlot()
      else
        @fetchInfoForGraph()

    handleManualResize: -> @showPlot()

    showPlot: ->
      @compResGraphView.render()
      @setUpEmbedModal()

    #-------------------------------------------------------------------------------------------------------------------
    # Embedding
    #-------------------------------------------------------------------------------------------------------------------
    setUpEmbedModal: ->

      glados.helpers.EmbedModalsHelper.initEmbedModalForCollectionView(
        glados.views.SearchResults.ESResultsGraphView.EMBED_PATH_RELATIVE_GENERATOR,
        @
      )


glados.views.SearchResults.ESResultsGraphView.EMBED_PATH_RELATIVE_GENERATOR = Handlebars.compile('#view_for_collection/plot/state/{{state}}')

glados.views.SearchResults.ESResultsGraphView.initEmbedded = (initFunctionParams) ->

  encodedState = initFunctionParams.state
  state = JSON.parse(atob(encodedState))
  list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFromState(state)

  viewConfig =
    embedded: true

  new glados.views.SearchResults.ESResultsGraphView
    collection: list
    el: $('#BCK-embedded-content')
    config: viewConfig

  list.fetch()
