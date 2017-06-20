# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsBioactivitySummaryView: Backbone.View.extend

    MAX_AGGREGATIONS: 3

    initialize: ->
      console.log 'ESResultsBioactivitySummaryView initialised!!'
      @activitiesSummarylist = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewBioactivitiesSummaryList()

      glados.views.PaginatedViews.PaginatedView.getNewTablePaginatedView(@activitiesSummarylist, 
        $(@el).find('.BCK-summary-table-container'))

      @paintFieldsSelectors(@activitiesSummarylist.getMeta('default_comparators'))
      @activitiesSummarylist.fetch()

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
