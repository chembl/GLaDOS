# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsBioactivitySummaryView: Backbone.View.extend

    MAX_AGGREGATIONS: 3

    initialize: ->
      @activitiesSummarylist = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewBioactivitiesSummaryList()
      @activitiesSummarylist.on 'reset do-repaint sort', @handleVisualisationStatus, @
      @collection.on glados.Events.Collections.SELECTION_UPDATED, @handleVisualisationStatus, @

      glados.views.PaginatedViews.PaginatedView.getNewTablePaginatedView(@activitiesSummarylist, 
        $(@el).find('.BCK-summary-table-container'), undefined, disableColumnsSelection=true, disableItemSelection=true)

      @handleVisualisationStatus()
      @paintFieldsSelectors(@activitiesSummarylist.getMeta('default_comparators'))

    paintFieldsSelectors: (currentComparators) ->
      $columnsSelectorContainer = $(@el).find('.BCK-columns-selector-container')
      columnsDescriptions = []

      for i in [0..@MAX_AGGREGATIONS-1]
        selectedComparator = currentComparators[i]
        alreadyChosenComparatos = _.without(currentComparators, selectedComparator)
        availableOptions = []

        for key, field of Activity.COLUMNS

          if not field.use_in_summary
            continue
          if _.contains(alreadyChosenComparatos, field.comparator)
            continue

          option =
            is_selected: field.comparator == selectedComparator
            value: i + '-' + field.comparator
            name_to_show: field.name_to_show

          availableOptions.push option

        currentColumnOptions =
          columnNumber: (i + 1)
          fields: availableOptions
        columnsDescriptions.push(currentColumnOptions)

      glados.Utils.fillContentForElement $columnsSelectorContainer,
        columnsDescriptions: columnsDescriptions

      $(@el).find('select').material_select()

      handleColumnFieldChangeProxy = $.proxy(@handleColumnFieldChange, @)
      $(@el).find('.BCK-Bioactivity-column-select').change ->
        if @value?
          handleColumnFieldChangeProxy @value

    handleColumnFieldChange: (selectedValue) ->

      valueParts = selectedValue.split('-')
      colNum = valueParts[0]
      comparator = valueParts[1]
      currentComparators = @activitiesSummarylist.getMeta('current_comparators')
      currentComparators[colNum] = comparator
      @activitiesSummarylist.setMeta('current_comparators', currentComparators)
      @paintFieldsSelectors(currentComparators)
      @setProgressMessage('loading... ')
      @hideTable()
      @activitiesSummarylist.fetch()

    setProgressMessage: (msg, hideCog=false, linkUrl, linkText) ->

      $messagesElement = $(@el).find('.BCK-VisualisationMessages')
      glados.Utils.fillContentForElement $messagesElement,
        message: msg
        hide_cog: hideCog
        link_url: linkUrl
        link_text: linkText

    wakeUpView: ->
      @handleVisualisationStatus()

    handleVisualisationStatus: ->

      # only bother if my element is visible
      if not $(@el).is(":visible")
        return

      numSelectedItems = @collection.getNumberOfSelectedItems()
      threshold = glados.Settings.VIEW_SELECTION_THRESHOLDS['Bioactivity']

      if numSelectedItems < threshold[0]
        @setProgressMessage('Please select at least ' + threshold[0] + ' target to show this visualisation.',
          hideCog=true)
        @hideTable()
        return

      if numSelectedItems > threshold[1]
        @setProgressMessage('Please select less than ' + threshold[1] + ' targets to show this visualisation.',
          hideCog=true)
        @hideTable()
        return


      selectedIDs = @collection.getSelectedItemsIDs()

      IDsListAttrName = 'origin_chembl_ids'
      originChemblIDS = @activitiesSummarylist.getMeta(IDsListAttrName)
      @activitiesSummarylist.setMeta('origin_chembl_ids', selectedIDs, undefined, trackPreviousValue=true)

      if originChemblIDS? and not @activitiesSummarylist.metaListHasChanged(IDsListAttrName)
        filter = 'target_chembl_id:(' + ('"' + id + '"' for id in originChemblIDS).join(' OR ') + ')'
        url = Activity.getActivitiesListURL(filter)

        @setProgressMessage('Showing results for the selected targets ' + '(' + numSelectedItems + ').',
          hideCog=true, linkURL=url, linkText='Browse all activities for those targets.')
        @showTable()
        return

      @setProgressMessage('Filtering activities...')

      @setTargetChemblIDsAndFetch(selectedIDs)

    setTargetChemblIDsAndFetch: (selectedIDs) ->

      if selectedIDs == glados.Settings.INCOMPLETE_SELECTION_LIST_LABEL
        $messagesElement = $(@el).find('.BCK-VisualisationMessages')
        deferreds = @collection.getAllResults($messagesElement)

        thisView = @
        f = $.proxy(@setTargetChemblIDsAndFetch, @)
        $.when.apply($, deferreds).done( -> f(thisView.collection.getSelectedItemsIDs()))
        .fail( (msg) -> thisView.setProgressMessage('Error: ', msg) )
        return


      @activitiesSummarylist.setMeta('origin_chembl_ids', selectedIDs, undefined, trackPreviousValue=true)
      @activitiesSummarylist.fetch()

    hideTable: -> $(@el).find('.BCK-summary-table-container').hide()
    showTable: -> $(@el).find('.BCK-summary-table-container').show()

