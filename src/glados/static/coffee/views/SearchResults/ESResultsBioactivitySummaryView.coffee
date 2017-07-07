# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsBioactivitySummaryView: Backbone.View.extend

    MAX_AGGREGATIONS: 3

    initialize: ->

      @ctm = new glados.models.Activity.ActivityAggregationMatrix()
      @collection.on glados.Events.Collections.SELECTION_UPDATED, @handleVisualisationStatus, @

      @ctmView = new MatrixView
        model: @ctm
        el: $(@el).find('.BCK-CompTargetMatrix')

      @handleVisualisationStatus()

    #-------------------------------------------------------------------------------------------------------------------
    # Progess Message
    #-------------------------------------------------------------------------------------------------------------------
    setProgressMessage: (msg, hideCog=false, linkUrl, linkText) ->

      $messagesElement = $(@el).find('.BCK-VisualisationMessages')
      glados.Utils.fillContentForElement $messagesElement,
        message: msg
        hide_cog: hideCog
        link_url: linkUrl
        link_text: linkText

    #------------------------------------------------------------------------------------------------------------------
    # Handle visualisation status
    #-------------------------------------------------------------------------------------------------------------------
    wakeUpView: ->
      @handleVisualisationStatus()

    handleVisualisationStatus: ->
      console.log 'HANDLE VISUALISATION STATUS!'
      return

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

