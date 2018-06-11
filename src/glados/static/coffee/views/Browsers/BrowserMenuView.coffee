# this view is in charge of handling the menu bar that appears on top of the results
glados.useNameSpace 'glados.views.Browsers',
  BrowserMenuView: Backbone.View.extend

    DEFAULT_RESULTS_VIEWS_BY_TYPE:
      'Graph': glados.views.SearchResults.ESResultsGraphView
      'Table': glados.views.PaginatedViews.PaginatedViewFactory.getTableConstructor()
      'Cards': glados.views.PaginatedViews.PaginatedViewFactory.getCardsConstructor()
      'Infinite': glados.views.PaginatedViews.PaginatedViewFactory.getInfiniteConstructor()
      Heatmap: glados.views.SearchResults.ESResultsBioactivitySummaryView

    events:
      'click .BCK-download-btn-for-format': 'triggerAllItemsDownload'
      'click .BCK-btn-switch-view': 'switchResultsView'
      'click .BCK-toggle-clear-selections': 'toggleClearSelections'

    initialize: ->

      @showPreloader()
      @collection.on 'reset do-repaint sort', @renderViewState, @
      @collection.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.FACETS_FETCHING_STATE_CHANGED,
      @renderViewState, @

      @collection.on glados.Events.Collections.SELECTION_UPDATED, @handleSelection, @

      @currentViewType = @collection.getMeta('default_view')

      # This handles all the views this menu view handles, there is one view per view type, for example
      # {'Table': <instance of table view>}
      @allViewsPerType = {}
      @viewContainerID = @collection.getMeta('id_name')
      @$viewContainer = $(@el).find('.BCK-View-Container').attr('id', @viewContainerID)

      @toolBarView = new glados.views.Browsers.BrowserToolBarView
        collection: @collection
        el: $(@el).find('.BCK-ToolBar-Container')
        menu_view: @

      @$facetsElem = $(@el).find('.BCK-Facets-Container')
      @facetsView = new glados.views.Browsers.BrowserFacetView
        collection: @collection
        el: $(@el).find('.BCK-Facets-Container')
        menu_view: @

      @showOrCreateView @currentViewType

    wakeUp: ->
      @toolBarView.wakeUp()
      @facetsView.wakeUp()
      @wakeUpCurrentView()

    sleep: ->
      @sleepCurrentView()

    wakeUpCurrentView: ->

      $currentViewInstance = @getCurrentViewInstance()
      if $currentViewInstance.wakeUpView?
        $currentViewInstance.wakeUpView()

    sleepCurrentView: ->

      $currentViewInstance = @getCurrentViewInstance()
      if $currentViewInstance.sleepView?
        $currentViewInstance.sleepView()

    renderViewState: ->

      if not $(@el).is(":visible")
        return

      if not @collection.isReady() and not @collection.isStreaming()
        @showPreloader()
        return

      @renderMenuContent()
      if @collection.getMeta('total_records') != 0

        $downloadBtnsContainer = $(@el).find('.BCK-download-btns-container')
        $downloadBtnsContainer.html Handlebars.compile($('#' + $downloadBtnsContainer.attr('data-hb-template')).html())
          formats: @collection.getMeta('download_formats')

        @handleSelection()
        $changeViewBtnsContainer = $(@el).find('.BCK-changeView-btns-container')
        glados.Utils.fillContentForElement $changeViewBtnsContainer,
          options: ( {
            label: viewLabel,
            icon_class: glados.Settings.DEFAULT_RESULTS_VIEWS_ICONS[viewLabel]
            is_disabled: @checkIfViewMustBeDisabled(viewLabel)[0]
            disable_reason: @checkIfViewMustBeDisabled(viewLabel)[1]
          } for viewLabel in @collection.getMeta('available_views'))

        @selectButton @currentViewType

      @addRemoveQtipToButtons()

    renderMenuContent: ->

      $menuContainer = $(@el).find('.BCK-Browser-Menu-Container')
      glados.Utils.fillContentForElement($menuContainer)

    showPreloader: ->

      $menuContainer = $(@el).find('.BCK-Browser-Menu-Container')
      glados.Utils.fillContentForElement($menuContainer, paramsObj={msg:'Loading Menu...'}, customTemplate=undefined,
        fillWithPreloader=true)

    #--------------------------------------------------------------------------------------
    # Filters
    #--------------------------------------------------------------------------------------
    hideFilters: ->

      $filtersContainer = $(@el).find('.BCK-Facets-Container')
      $filtersContainer.addClass('facets-hidden')

      $pagItemsContainer = $(@el).find('.BCK-View-Container')
      $pagItemsContainer.addClass('facets-hidden')

      @manualResizeCurrentView()

    showFilters: ->

      $filtersContainer = $(@el).find('.BCK-Facets-Container')
      $filtersContainer.removeClass('facets-hidden')

      $pagItemsContainer = $(@el).find('.BCK-View-Container')
      $pagItemsContainer.removeClass('facets-hidden')

      @manualResizeCurrentView()

    collapseAllFilters: -> @facetsView.collapseAllFilters()
    expandAllFilters: -> @facetsView.expandAllFilters()

    manualResizeCurrentView: ->

      currentView = @getCurrentViewInstance()
      if currentView?
        currentView.handleManualResize() unless not currentView.handleManualResize?
    #--------------------------------------------------------------------------------------
    # Selections
    #--------------------------------------------------------------------------------------
    checkIfViewMustBeDisabled: (viewLabel) ->

      if @collection.isStreaming() and (viewLabel in glados.Settings.VIEWS_DISABLED_WHILE_STREAMING)
        return [true, glados.views.Browsers.BrowserMenuView.DISABLE_BUTTON_REASONS.IS_STREAMING]

      if glados.Settings.VIEW_SELECTION_THRESHOLDS[viewLabel]?
        numSelectedItems = @collection.getNumberOfSelectedItems()
        threshold = glados.Settings.VIEW_SELECTION_THRESHOLDS[viewLabel]
        if threshold[0] <= numSelectedItems <= threshold[1]
          return [false]
        else
          return [true, glados.views.Browsers.BrowserMenuView.DISABLE_BUTTON_REASONS.TOO_MANY_ITEMS]

      return [false]

    handleSelection: ->

      if not @collection.itemsAreReady()
        return

      $selectionMenuContainer = $(@el).find('.BCK-selection-menu-container')
      out_of_n = @collection.getMeta('out_of_n')
      numSelectedItems = @collection.getNumberOfSelectedItems()
      glados.Utils.fillContentForElement $selectionMenuContainer,
        out_of_n: if out_of_n > 0 then glados.Utils.getFormattedNumber(out_of_n) else false
        num_selected: numSelectedItems
        hide_num_selected: numSelectedItems == 0
        total_items: glados.Utils.getFormattedNumber @collection.getMeta('total_records')
        entity_label: @collection.getMeta('label')
        none_is_selected: not @collection.getMeta('all_items_selected') and not @collection.thereAreExceptions()
      _.defer ->
        $selectionMenuContainer.find('.tooltipped').tooltip()

      for viewLabel in @collection.getMeta('available_views')
        [viewMustBeDisabled, reason] = @checkIfViewMustBeDisabled(viewLabel)
        if viewMustBeDisabled
          @disableButton(viewLabel, reason)
        else
          @enableButton(viewLabel)

      @renderLinkToAll() unless not @collection.islinkToAllActivitiesEnabled()

    toggleClearSelections: -> @collection.toggleClearSelections()

    renderLinkToAll: ->

      if @collection.getTotalRecords() == 0
        return

      $selectionMenuContainer = $(@el).find('.BCK-selection-menu-container')
      $linkToAllContainer = $selectionMenuContainer.find('.BCK-LinkToAllActivitiesContainer')

      tooManyItems = @collection.thereAreTooManyItemsForActivitiesLink()
      isStreaming = @collection.isStreaming()
      needsToBeDisabled = tooManyItems or isStreaming

      if needsToBeDisabled

        glados.Utils.fillContentForElement $linkToAllContainer,
          too_many_items: true


        qtipText = switch
          when isStreaming then \
          "Please wait until the download is complete"
          when tooManyItems then \
          "Please select or filter less than #{glados.Settings.VIEW_SELECTION_THRESHOLDS.Heatmap[1]} " +
          "items to activate this link."

        $linkToAllContainer.qtip
          content:
            text: qtipText
          style:
            classes:'qtip-light'
          position:
            my: 'top middle'
            at: 'bottom middle'

        return

      glados.Utils.fillContentForElement($linkToAllContainer)

      $link = $linkToAllContainer.find('.BCK-LinkToAllActivities')
      $link.click $.proxy(@handleLinkToAllActivitiesClick, @)


    handleLinkToAllActivitiesClick: ->

      $selectionMenuContainer = $(@el).find('.BCK-selection-menu-container')
      $linkToAllContainer = $selectionMenuContainer.find('.BCK-LinkToAllActivitiesContainer')
      $preloader = $linkToAllContainer.find('.BCK-preloader')
      $preloader.show()

      linkToActPromise = @collection.getLinkToAllActivitiesPromise()

      linkToActPromise.then (linkGot) ->
        glados.Utils.URLS.shortenLinkIfTooLongAndOpen(linkGot)
        $preloader.hide()

    #--------------------------------------------------------------------------------------
    # Download Buttons
    #--------------------------------------------------------------------------------------

    triggerAllItemsDownload: (event) ->
      desiredFormat = $(event.currentTarget).attr('data-format')
      $progressMessages = $(@el).find('.download-messages-container')
      @collection.downloadAllItems(desiredFormat, undefined, $progressMessages)

    #--------------------------------------------------------------------------------------
    # Switching Views
    #--------------------------------------------------------------------------------------
    addRemoveQtipToButtons: ->
      $allButtons = $(@el).find('.BCK-btn-switch-view')
      $allButtons.qtip('destroy', true)
      $disabledButtons = $allButtons.filter('.disabled')
      thisView = @
      $($disabledButtons).each ->

        $currentElem = $(@)
        viewLabel = $currentElem.attr('data-view')
        disableReason = $currentElem.attr('data-disabled-reason')

        $currentElem.qtip
          content:
            text: thisView.getDisableReasonMessage(disableReason, viewLabel)
          style:
            classes:'qtip-light'
          position:
            my: 'top left'
            at: 'bottom middle'

    getDisableReasonMessage: (disableReason, viewLabel) ->

      if disableReason == glados.views.Browsers.BrowserMenuView.DISABLE_BUTTON_REASONS.TOO_MANY_ITEMS

        threshold = 'some'
        if glados.Settings.VIEW_SELECTION_THRESHOLDS[viewLabel]?
          thresholdNum = glados.Settings.VIEW_SELECTION_THRESHOLDS[viewLabel]
          threshold = 'from ' + thresholdNum[0] + ' to ' + thresholdNum[1]

        return "Select #{threshold} items to activate this view."

      if disableReason == glados.views.Browsers.BrowserMenuView.DISABLE_BUTTON_REASONS.IS_STREAMING

        return "Please wait until the download is complete to activate this view."

    unSelectAllButtons: ->
      $(@el).find('.BCK-btn-switch-view').removeClass('selected')

    selectButton: (type) ->
      $(@el).find('[data-view=' + type + ']').addClass('selected')

    disableButton: (type, reason) ->
      $buttonToDisable = $(@el).find('[data-view=' + type + ']')
      $buttonToDisable.addClass('disabled')
      $buttonToDisable.attr('data-disabled-reason', reason)
      @addRemoveQtipToButtons()

    enableButton: (type) ->
      $buttonToEnable = $(@el).find('[data-view=' + type + ']')
      $buttonToEnable.removeClass('disabled')
      @addRemoveQtipToButtons()

    switchResultsView: (event) ->
      $clickedElem = $(event.currentTarget)

      if $clickedElem.hasClass('disabled')
        return

      desiredViewType = $clickedElem.attr('data-view')

      @unSelectAllButtons()
      @selectButton desiredViewType

      @hideView @currentViewType
      @currentViewType = desiredViewType
      @showOrCreateView desiredViewType

    # if the view already exists, shows it, otherwise it creates it.
    showOrCreateView: (viewType) ->

      console.log 'show or create view: ', viewType
      viewElementID = @viewContainerID + '-' + viewType

      # Does the view exist already?
      if !@allViewsPerType[viewType]?
        # No, it does not exist
        console.log 'view does not exist yet'

        $viewContainer = $('#' + @viewContainerID)
        $viewElement = $('<div>').attr('id', viewElementID).addClass('position-relative')
        templateName = 'Handlebars-Common-ESResultsList' + viewType + 'View'
        $viewElement.html Handlebars.compile($('#' + templateName).html())()
        $viewContainer.append($viewElement)

        if viewType == 'Bioactivity' or viewType == 'Graph'
          newView = new @DEFAULT_RESULTS_VIEWS_BY_TYPE[viewType]
            collection: @collection
            el: $viewElement
        else

          viewConfig =
            show_embed_button: true
            enable_cards_zoom: true
          # Instantiates the results list view for each ES entity and links them with the html component
          newView = new @DEFAULT_RESULTS_VIEWS_BY_TYPE[viewType]
            collection: @collection
            el: $viewElement
            # this is used for paginated cards and table only
            custom_render_evts: undefined
            render_at_init: true
            zoom_controls_container: @toolBarView.getZoomControlsContainer()
            special_structures_toggler: @toolBarView.getSpecialStructureControlsContainer()
            attributes:
              include_search_results_highlight: @attributes?.include_search_results_highlight || false
            config: viewConfig

        @allViewsPerType[viewType] = newView

      else
        # yes it already exists
        # wake up the view if necessary
        console.log 'view already existed'
        @allViewsPerType[viewType].wakeUpView() unless not @allViewsPerType[viewType].wakeUpView?

      $('#' + viewElementID).show()
      currentView = @allViewsPerType[viewType]

      showZoomControls = false
      if currentView.isCards?
        if (currentView.isCards() or currentView.isInfinite()) and @collection.getMeta('enable_cards_zoom')
          showZoomControls = true

      if showZoomControls
        @toolBarView.showZoomControls()
      else
        @toolBarView.hideZoomControls()

      showSpecialStructureControls = false
      if currentView.isCards?
        if (currentView.isCards() or currentView.isInfinite()) and (@collection.getMeta('enable_similarity_maps') \
        or @collection.getMeta('enable_substructure_highlighting'))
          showSpecialStructureControls = true

      if showSpecialStructureControls
        @toolBarView.showSpecialStructureControls()
      else
        @toolBarView.hideSpecialStructureControls()

    hideView: (viewType) ->

      @allViewsPerType[viewType].sleepView() unless not @allViewsPerType[viewType].sleepView?

      viewElementID = @viewContainerID + '-' + viewType
      $('#' + viewElementID).hide()

    getCurrentViewInstance: -> @allViewsPerType[@currentViewType]
    #--------------------------------------------------------------------------------------
    # Zoom
    #--------------------------------------------------------------------------------------
    zoomIn: -> @getCurrentViewInstance().zoomIn()
    zoomOut: -> @getCurrentViewInstance().zoomOut()
    resetZoom: -> @getCurrentViewInstance().resetZoom()

    #--------------------------------------------------------------------------------------
    # Deferred Structures
    #--------------------------------------------------------------------------------------
    toggleShowSpecialStructure: (checked) -> @getCurrentViewInstance().toggleShowSpecialStructure(checked)


glados.views.Browsers.BrowserMenuView.DISABLE_BUTTON_REASONS =
  TOO_MANY_ITEMS: 'TOO_MANY_ITEMS'
  IS_STREAMING: 'IS_STREAMING'