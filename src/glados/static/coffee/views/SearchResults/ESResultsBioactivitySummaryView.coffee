# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsBioactivitySummaryView: Backbone.View.extend

    initialize: ->

#      @collection.on glados.Events.Collections.SELECTION_UPDATED, @handleVisualisationStatus, @
#      @collection.on 'reset', @handleVisualisationStatus, @

      @sourceEntity = @collection.getMeta('model').prototype.entityName

      heatmapConfigGenerator = new glados.configs.ReportCards.Visualisation.Heatmaps.CompoundsVSTargetsHeatmap(@collection)
      modelConfig = heatmapConfigGenerator.getHeatmapModelConfig()
      viewConfig = heatmapConfigGenerator.getViewConfig()

      @heatmap = new glados.models.Heatmap.Heatmap
        config: modelConfig

      @ctmView = new glados.views.Visualisation.Heatmap.HeatmapView
        model: @heatmap
        el: $(@el).find('.BCK-CompTargetMatrix')
        config: viewConfig
        parent_view: @

    #-------------------------------------------------------------------------------------------------------------------
    # Progess Message
    #-------------------------------------------------------------------------------------------------------------------
    setProgressMessage: (msg, hideCog=false, linkUrl, linkText, showWarningIcon=false) ->

      $messagesElement = $(@el).find('.BCK-ViewHandlerMessages')
      $messagesElement.show()
      glados.Utils.fillContentForElement $messagesElement,
        message: msg
        hide_cog: hideCog
        link_url: linkUrl
        link_text: linkText
        show_warning_icon: showWarningIcon

    hideProgressElement: -> $(@el).find('.BCK-ViewHandlerMessages').hide()
    #------------------------------------------------------------------------------------------------------------------
    # Handle visualisation status
    #-------------------------------------------------------------------------------------------------------------------
    getVisibleColumns: -> _.union(@collection.getMeta('columns'), @collection.getMeta('additional_columns'))
    wakeUpView: ->
      @collection.wakeUp()
      @handleVisualisationStatus()

    sleepView: ->
#      @ctmView.destroyAllTooltips()
    handleManualResize: ->
#      @ctmView.render()

    handleVisualisationStatus: ->

      console.log 'handleVisualisationStatus', @collection
      # only bother if my element is visible
      if not $(@el).is(":visible")
        return

      if not @collection.isReady()
        return

      numTotalItems = @collection.getMeta('total_records')
      if numTotalItems == 0
        @setProgressMessage('No data to show',hideCog=true)
        return

      numSelectedItems = @collection.getNumberOfSelectedItems()
      thereIsSelection = numSelectedItems > 0
      threshold = glados.Settings.VIEW_SELECTION_THRESHOLDS['Heatmap']
      numWorkingItems = if thereIsSelection then numSelectedItems else numTotalItems

      if numWorkingItems > threshold[1]
        @setProgressMessage('Please select or filter less than ' + threshold[1] + ' ' + @sourceEntity + ' to show this visualisation.',
          hideCog=true)
        @hideMatrix()
        return

      @heatmap.startLoad()

    showDisplayAnywayButton: -> $(@el).find('.BCK-ShowAnywayButtonContainer').show()
    hideDisplayAnywayButton: -> $(@el).find('.BCK-ShowAnywayButtonContainer').hide()
    hideMatrix: -> $(@el).find('.BCK-CompTargetMatrix').hide()
    showMatrix: ->
      $(@el).find('.BCK-CompTargetMatrix').show()
      @setUpEmbedModal()

    setUpEmbedModal: ->

      glados.helpers.EmbedModalsHelper.initEmbedModalForCollectionView(
        glados.views.SearchResults.ESResultsBioactivitySummaryView.EMBED_PATH_RELATIVE_GENERATOR,
        @
      )


glados.views.SearchResults.ESResultsBioactivitySummaryView.EMBED_PATH_RELATIVE_GENERATOR =
Handlebars.compile('#view_for_collection/heatmap/state/{{state}}')

glados.views.SearchResults.ESResultsBioactivitySummaryView.initEmbedded = (initFunctionParams) ->

  encodedState = initFunctionParams.state
  state = JSON.parse(atob(encodedState))

  list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFromState(state)

  new glados.views.SearchResults.ESResultsBioactivitySummaryView
    collection: list
    el: $('#BCK-embedded-content')

  list.fetch()

