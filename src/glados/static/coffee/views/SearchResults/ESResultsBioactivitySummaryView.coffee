# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsBioactivitySummaryView: Backbone.View.extend

    events:
      'click .BCK-show-anyway': 'displayAnyway'

    initialize: ->

      console.log 'BIOACTIVITY!'
#      @collection.on glados.Events.Collections.SELECTION_UPDATED, @handleVisualisationStatus, @
#      @collection.on glados.Events.Collections.SELECTION_UPDATED, (-> console.log('... SELECTION UPDATED'), @
      @collection.on 'reset do-repaint', @handleVisualisationStatus, @

      @entityName = @collection.getMeta('label')
      if @entityName == 'Targets'
        filterProperty = 'target_chembl_id'
        aggList = ['target_chembl_id', 'molecule_chembl_id']
        rowsEntityName = 'Targets'
        rowsLabelProperty = 'target_pref_name'
        colsEntityName = 'Compounds'
        colsLabelProperty = 'molecule_chembl_id'

      else
        filterProperty = 'molecule_chembl_id'
        aggList = ['molecule_chembl_id', 'target_chembl_id']
        rowsEntityName = 'Compounds'
        rowsLabelProperty = 'molecule_chembl_id'
        colsEntityName = 'Targets'
        colsLabelProperty = 'target_pref_name'

      config = {
        rows_entity_name: rowsEntityName
        cols_entity_name: colsEntityName
        properties:
          molecule_chembl_id: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound',
              'CHEMBL_ID')
          target_chembl_id: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Target',
              'CHEMBL_ID')
          target_pref_name: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Target',
              'PREF_NAME')
          pchembl_value_avg: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
              'PCHEMBL_VALUE_AVG')
          activity_count: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
              'ACTIVITY_COUNT')
          hit_count: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
              'HIT_COUNT')
          pchembl_value_max: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
              'PCHEMBL_VALUE_MAX')
        initial_colouring: 'pchembl_value_avg'
        colour_properties: ['activity_count', 'pchembl_value_avg']
        initial_row_sorting: 'activity_count'
        initial_row_sorting_reverse: true
        row_sorting_properties: ['activity_count', 'pchembl_value_max', 'hit_count']
        initial_col_sorting: 'activity_count'
        initial_col_sorting_reverse: true
        col_sorting_properties: ['activity_count', 'pchembl_value_max', 'hit_count']
        initial_col_label_property: colsLabelProperty
        initial_row_label_property: rowsLabelProperty
        propertyToType:
          activity_count: "number"
          pchembl_value_avg: "number"
          pchembl_value_max: "number"
          hit_count: "number"
      }

      @ctm = new glados.models.Activity.ActivityAggregationMatrix
        filter_property: filterProperty
        aggregations: aggList

      @ctmView = new MatrixView
        model: @ctm
        el: $(@el).find('.BCK-CompTargetMatrix')
        config: config

      @handleVisualisationStatus()

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
      console.log '... WAKING UP MATRIX'
      @handleVisualisationStatus()
    sleepView: -> @ctmView.destroyAllTooltips()

    handleVisualisationStatus: ->

      # only bother if my element is visible
      if not $(@el).is(":visible")
        return

      if @collection.loading_facets
        console.log '... LOADING FACETS!'
      else
        console.log '... NOT LOADING FACETS!'

      numTotalItems = @collection.getMeta('total_records')
      @hideDisplayAnywayButton()
      if numTotalItems == 0
        @setProgressMessage('No data to show',hideCog=true)
        return

      numSelectedItems = @collection.getNumberOfSelectedItems()
      thereIsSelection = numSelectedItems > 0
      threshold = glados.Settings.VIEW_SELECTION_THRESHOLDS['Bioactivity']
      numWorkingItems = if thereIsSelection then numSelectedItems else numTotalItems
      console.log '... numWorkingItems: ', numWorkingItems

      if numWorkingItems > threshold[1]
        @setProgressMessage('Please select or filter less than ' + threshold[1] + ' ' + @entityName + ' to show this visualisation.',
          hideCog=true)
        @hideMatrix()
        return

      if numWorkingItems > threshold[2] and not @FORCE_DISPLAY
        msg = 'I am going to generate this visualisation from ' + numWorkingItems +  ' ' + @entityName +
          '. This can cause your browser to slow down. Press the following button to override this warning.'

        @setProgressMessage(msg, hideCog=true, linkUrl=undefined, linkText=undefined, showWarningIcon=true)
        @showDisplayAnywayButton()
        @hideMatrix()
        return

      console.log '... is there selection?'
      @setProgressMessage('', hideCog=true)
      if not thereIsSelection
        console.log '... there is no selection'
        @getAllChemblIDsAndFetch()
        return

      @setProgressMessage('Filtering activities...')
      selectedIDs = @collection.getSelectedItemsIDs()
      @getChemblIDsAndFetchFromSelection(selectedIDs)

      return

    showDisplayAnywayButton: -> $(@el).find('.BCK-ShowAnywayButtonContainer').show()
    hideDisplayAnywayButton: -> $(@el).find('.BCK-ShowAnywayButtonContainer').hide()
    hideMatrix: -> $(@el).find('.BCK-CompTargetMatrix').hide()
    showMatrix: -> $(@el).find('.BCK-CompTargetMatrix').show()

    displayAnyway: ->
      @FORCE_DISPLAY = true
      @handleVisualisationStatus()

    #-------------------------------------------------------------------------------------------------------------------
    # Get items to generate matrix
    #-------------------------------------------------------------------------------------------------------------------
    fillLinkToAllActivities: ->
      glados.Utils.fillContentForElement $(@el).find('.BCK-See-all-activities'),
        url: @ctm.getLinkToAllActivities()

    getAllChemblIDsAndFetch: (requiredIDs) ->

      $messagesElement = $(@el).find('.BCK-ViewHandlerMessages').first()
      deferreds = @collection.getAllResults($messagesElement)

      thisView = @
      $.when.apply($, deferreds).done( ->
        filterProperty = thisView.ctm.get('filter_property')
        allItemsIDs = (item[filterProperty] for item in thisView.collection.allResults)
        console.log 'allItemsIDs: ', allItemsIDs
        thisView.ctm.set('chembl_ids', allItemsIDs, {silent:true} )
        thisView.ctm.fetch()
        thisView.setProgressMessage('', hideCog=true)
        thisView.hideProgressElement()
        thisView.showMatrix()
        thisView.fillLinkToAllActivities()
      ).fail( (msg) -> thisView.setProgressMessage('Error: ', msg) )


    getChemblIDsAndFetchFromSelection: (selectedIDs) ->

      if selectedIDs == glados.Settings.INCOMPLETE_SELECTION_LIST_LABEL
        $messagesElement = $(@el).find('.BCK-ViewHandlerMessages')
        deferreds = @collection.getAllResults($messagesElement)

        thisView = @
        f = $.proxy(@getChemblIDsAndFetchFromSelection, @)
        $.when.apply($, deferreds).done( -> f(thisView.collection.getSelectedItemsIDs()))
        .fail( (msg) -> thisView.setProgressMessage('Error: ', msg) )
        return

      @ctm.set('chembl_ids', selectedIDs, {silent:true})
      console.log '... FETCH MATRIX!'
      @ctm.fetch()
      @showMatrix()
      @setProgressMessage('', hideCog=true)
      @hideProgressElement()
      @fillLinkToAllActivities()




