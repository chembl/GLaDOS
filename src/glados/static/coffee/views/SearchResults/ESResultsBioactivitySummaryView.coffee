# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsBioactivitySummaryView: Backbone.View.extend

    MAX_AGGREGATIONS: 3

    initialize: ->
      console.log 'ESResultsBioactivitySummaryView initialised!!'
      @activitiesSummarylist = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewBioactivitiesSummaryList()
      @activitiesSummarylist.on 'reset do-repaint sort', @showVisualisationStatus, @
      @collection.on glados.Events.Collections.SELECTION_UPDATED, @showVisualisationStatus, @

      glados.views.PaginatedViews.PaginatedView.getNewTablePaginatedView(@activitiesSummarylist, 
        $(@el).find('.BCK-summary-table-container'))

      @showVisualisationStatus()
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
      @activitiesSummarylist.fetch()

    setProgressMessage: (msg, hideCog=false) ->

      $messagesElement = $(@el).find('.BCK-VisualisationMessages')
      glados.Utils.fillContentForElement $messagesElement,
        message: msg
        hide_cog: hideCog

    showVisualisationStatus: ->

      numSelectedItems = @collection.getNumberOfSelectedItems()
      threshold = glados.Settings.VIEW_SELECTION_THRESHOLDS['Bioactivity']

      if numSelectedItems < threshold[0]
        @setProgressMessage('Please select at least ' + threshold[0] + ' item to show this visualisation.',
          hideCog=true)
        return

      if numSelectedItems > threshold[1]
        @setProgressMessage('Please select less than ' + threshold[1] + ' items to show this visualisation.',
          hideCog=true)
        return

      @setProgressMessage('Filtering activities...')
      selectedIDs = @collection.getSelectedItemsIDs()
      console.log 'selectedIDs: ', selectedIDs
      console.log 'selectedIDs: ', JSON.stringify(selectedIDs)

      @activitiesSummarylist.setMeta('origin_chembl_ids', selectedIDs)
      @activitiesSummarylist.fetch()

