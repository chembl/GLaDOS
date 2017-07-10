# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsBioactivitySummaryView: Backbone.View.extend

    MAX_AGGREGATIONS: 3

    events:
      'click .BCK-show-anyway': 'displayAnyway'

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
    setProgressMessage: (msg, hideCog=false, linkUrl, linkText, showWarningIcon=false) ->

      $messagesElement = $(@el).find('.BCK-VisualisationMessages')
      glados.Utils.fillContentForElement $messagesElement,
        message: msg
        hide_cog: hideCog
        link_url: linkUrl
        link_text: linkText
        show_warning_icon: showWarningIcon

    #------------------------------------------------------------------------------------------------------------------
    # Handle visualisation status
    #-------------------------------------------------------------------------------------------------------------------
    wakeUpView: ->
      @handleVisualisationStatus()

    handleVisualisationStatus: ->

      # only bother if my element is visible
      if not $(@el).is(":visible")
        return

      numTotalItems = @collection.getMeta('total_records')
      numSelectedItems = @collection.getNumberOfSelectedItems()
      thereIsSelection = numSelectedItems > 0
      threshold = glados.Settings.VIEW_SELECTION_THRESHOLDS['Bioactivity']
      numWorkingItems = if thereIsSelection then numSelectedItems else numTotalItems

      console.log 'numWorkingItems: ', numWorkingItems

      if numWorkingItems > threshold[1]
        @setProgressMessage('Please select or filter less than ' + threshold[1] + ' targets to show this visualisation.',
          hideCog=true)
        @hideMatrix()
        return

      if numWorkingItems > threshold[2] and not @FORCE_DISPLAY
        msg = 'I am going to generate this visualisation from ' + numWorkingItems +
          ' targets. This can cause your browser to slow down. Press the following button to override this warning.'

        @setProgressMessage(msg, hideCog=true, linkUrl=undefined, linkText=undefined, showWarningIcon=true)
        @showDisplayAnywayButton()
        @hideMatrix()
        return
      else
        @hideDisplayAnywayButton()

      @setProgressMessage('', hideCog=true)

      console.log 'GET DATA!!'
      if not thereIsSelection
        @getAllChemblIDsAndFetch()

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
        @showMatrix()
        return

      @setProgressMessage('Filtering activities...')

      @getChemblIDsAndFetchFromSelection(selectedIDs)

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
    getAllChemblIDsAndFetch: (requiredIDs) ->

      $messagesElement = $(@el).find('.BCK-VisualisationMessages').first()
      deferreds = @collection.getAllResults($messagesElement)

      thisView = @
      $.when.apply($, deferreds).done( ->
        allItemsIDs = (item.target_chembl_id for item in thisView.collection.allResults)
        console.log 'allItemsIDs: ', allItemsIDs

        moleculeIDs = ['CHEMBL59', 'CHEMBL138921', 'CHEMBL138040', 'CHEMBL457419']
        # use hardcoded list for now
        thisView.ctm.set('molecule_chembl_ids', moleculeIDs, {silent:true} )
        thisView.ctm.fetch()
      ).fail( (msg) -> thisView.setProgressMessage('Error: ', msg) )

      console.log 'getAllChemblIDsAndFetch'

    getChemblIDsAndFetchFromSelection: (requiredIDs) ->

      if requiredIDs == glados.Settings.INCOMPLETE_SELECTION_LIST_LABEL
        $messagesElement = $(@el).find('.BCK-VisualisationMessages')
        deferreds = @collection.getAllResults($messagesElement)

        thisView = @
        f = $.proxy(@getChemblIDsAndFetchFromSelection, @)
        $.when.apply($, deferreds).done( -> f(thisView.collection.getSelectedItemsIDs()))
        .fail( (msg) -> thisView.setProgressMessage('Error: ', msg) )
        return


      @activitiesSummarylist.setMeta('origin_chembl_ids', requiredIDs, undefined, trackPreviousValue=true)
      @activitiesSummarylist.fetch()



