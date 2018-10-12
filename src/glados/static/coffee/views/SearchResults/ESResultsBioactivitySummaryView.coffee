# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsBioactivitySummaryView: Backbone.View.extend

    events:
      'click .BCK-show-anyway': 'displayAnyway'

    initialize: ->

      @collection.on glados.Events.Collections.SELECTION_UPDATED, @handleVisualisationStatus, @
      @collection.on 'reset', @handleVisualisationStatus, @

      @sourceEntity = @collection.getMeta('label')
      if @sourceEntity == 'Targets'
        filterProperty = 'target_chembl_id'
        aggList = ['target_chembl_id', 'molecule_chembl_id']
      else
        filterProperty = 'molecule_chembl_id'
        aggList = ['molecule_chembl_id', 'target_chembl_id']

      heatmapModelConfigGenerator = new glados.configs.ReportCards.Visualisation.Heatmaps.CompoundsVSTargetsHeatmap(@collection)
      modelConfig = heatmapModelConfigGenerator.getHeatmapModelConfig()
      viewConfig = glados.views.Visualisation.Heatmap.HeatmapView.getDefaultConfig(@sourceEntity)

      console.log 'viewConfig: ', viewConfig


      @ctm = new glados.models.Heatmap.Heatmap
        config: modelConfig

      @ctmView = new glados.views.Visualisation.Heatmap.HeatmapView
        model: @ctm
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
      console.log 'bioact results view wake up'
      @collection.wakeUp()
      @handleVisualisationStatus()
    sleepView: -> @ctmView.destroyAllTooltips()
    handleManualResize: -> @ctmView.render()

    handleVisualisationStatus: ->

      # only bother if my element is visible
      if not $(@el).is(":visible")
        return

      if @collection.loading_facets
        return

      numTotalItems = @collection.getMeta('total_records')
      @hideDisplayAnywayButton()
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

      if numWorkingItems > threshold[2] and not @FORCE_DISPLAY
        msg = 'I am going to generate this visualisation from ' + numWorkingItems +  ' ' + @sourceEntity +
          '. This can cause your browser to slow down. Press the following button to override this warning.'

        @setProgressMessage(msg, hideCog=true, linkUrl=undefined, linkText=undefined, showWarningIcon=true)
        @showDisplayAnywayButton()
        @hideMatrix()
        return


      @setProgressMessage('', hideCog=true)
      if not thereIsSelection
        @getAllChemblIDsAndFetch()
        return

      @setProgressMessage('Filtering activities...')
      selectedIDs = @collection.getItemsIDs()
      @getChemblIDsAndFetchFromSelection(selectedIDs)

      return

    showDisplayAnywayButton: -> $(@el).find('.BCK-ShowAnywayButtonContainer').show()
    hideDisplayAnywayButton: -> $(@el).find('.BCK-ShowAnywayButtonContainer').hide()
    hideMatrix: -> $(@el).find('.BCK-CompTargetMatrix').hide()
    showMatrix: ->
      $(@el).find('.BCK-CompTargetMatrix').show()
      @setUpEmbedModal()

    displayAnyway: ->
      @FORCE_DISPLAY = true
      @handleVisualisationStatus()

    setUpEmbedModal: ->

      glados.helpers.EmbedModalsHelper.initEmbedModalForCollectionView(
        glados.views.SearchResults.ESResultsBioactivitySummaryView.EMBED_PATH_RELATIVE_GENERATOR,
        @
      )

    #-------------------------------------------------------------------------------------------------------------------
    # Get items to generate matrix
    #-------------------------------------------------------------------------------------------------------------------
    fillLinkToAllActivities: ->
      $elem = $(@el).find('.BCK-See-all-activities')
      glados.Utils.fillContentForElement $elem,
        url: @ctm.getLinkToAllActivities()
      $elem.show()

    hideLinkToAllActivities: -> $(@el).find('.BCK-See-all-activities').hide()

    getAllChemblIDsAndFetch: (requiredIDs) ->

      $messagesElement = $(@el).find('.BCK-ViewHandlerMessages').first()
      deferreds = @collection.getAllResults($messagesElement)
      @ctmView.clearVisualisation()

      thisView = @
      $.when.apply($, deferreds).done( ->
        filterProperty = thisView.ctm.get('filter_property')
        # TODO: probably fix these cases in a better way. Also some actions should be disabled while loading
        allItemsIDs = (item[filterProperty] for item in thisView.collection.allResults when item?)
#        thisView.ctm.set('chembl_ids', allItemsIDs)
#        thisView.ctm.fetch()
        thisView.setProgressMessage('', hideCog=true)
        thisView.hideProgressElement()
        thisView.showMatrix()
      ).fail( (msg) -> thisView.setProgressMessage('Error: ', msg) )


    getChemblIDsAndFetchFromSelection: (selectedIDs) ->

      if selectedIDs == glados.Settings.INCOMPLETE_SELECTION_LIST_LABEL
        $messagesElement = $(@el).find('.BCK-ViewHandlerMessages')
        deferreds = @collection.getAllResults($messagesElement)

        thisView = @
        f = $.proxy(@getChemblIDsAndFetchFromSelection, @)
        $.when.apply($, deferreds).done( -> f(thisView.collection.getItemsIDs()))
        .fail( (msg) -> thisView.setProgressMessage('Error: ', msg) )
        return

#      @ctm.set('chembl_ids', selectedIDs, {silent:true})
#      @ctm.fetch()
      @showMatrix()
      @setProgressMessage('', hideCog=true)
      @hideProgressElement()


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

