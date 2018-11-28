# this view is in charge of handling is the menu for a collection. It creates all the other subviews (filters, table view,
# heatmap, etc.
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

      @collection.on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.AWAKE_STATE_CHANGED,
        @handleListAwakeState, @

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
        el: @$facetsElem
        menu_view: @

      unless @collection.getMeta('streaming_mode')
        @$queryEditorElem = $(@el).find('.BCK-query-editor')
        @queryEditorView = new glados.views.Browsers.QueryEditorView
          collection: @collection
          el: @$queryEditorElem

      @showOrCreateView @currentViewType

    # ------------------------------------------------------------------------------------------------------------------
    # sleep awake view
    # ------------------------------------------------------------------------------------------------------------------
    handleListAwakeState: ->

      if @collection.isSleeping()
        @showPreloader()
      else
        @renderViewState()

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

    # ------------------------------------------------------------------------------------------------------------------
    # Waking up on scroll
    # ------------------------------------------------------------------------------------------------------------------
    setUpWakingUpWaypoint: ->

      # If search is ready I don't need to trigger fetch
      if @collection.searchIsReady()
        return

      waypointElem = $(@el)[0]
      thisView = @

      currentWindowHeight = window.innerHeight

      listenScroll = ->

        elemOffset = waypointElem.getBoundingClientRect()

        if elemOffset.top <= currentWindowHeight
          $(window).off('scroll', debouncedListener)
          thisView.wakeUp()

      debouncedListener = _.debounce(listenScroll, 100)
      $(window).scroll debouncedListener

    renderViewState: ->

      if not @collection.isReady() and not @collection.isStreaming()
        @showPreloader()
        return

      @renderMenuContent()
      if @collection.getMeta('total_records') != 0

        @showMenuContainer()
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
      else
        @hideMenuContainer()
      @addRemoveQtipToButtons()

    renderMenuContent: ->
      $menuContainer = $(@el).find('.BCK-Browser-Menu-Container')
      glados.Utils.fillContentForElement($menuContainer)

    hideMenuContainer: -> $(@el).find('.BCK-Browser-Menu-Container').hide()
    showMenuContainer: -> $(@el).find('.BCK-Browser-Menu-Container').show()
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

      @renderLinkToOtherEntities() unless not @collection.islinkToOtherEntitiesEnabled()

    toggleClearSelections: -> @collection.toggleClearSelections()

    renderLinkToOtherEntities: ->

      if @collection.getTotalRecords() == 0
        return

      $selectionMenuContainer = $(@el).find('.BCK-selection-menu-container')
      $linkToAllContainer = $selectionMenuContainer.find('.BCK-LinkToOtherEntitiesContainer')

      tooManyItems = @collection.thereAreTooManyItemsForActivitiesLink()
      isStreaming = @collection.isStreaming()
      needsToBeDisabled = tooManyItems or isStreaming

      availableDestinationEntities = []

      for entityName in @collection.getMeta('links_to_other_entities')
        availableDestinationEntities.push
          singular: entityName
          plural: glados.Settings.ENTITY_NAME_TO_ENTITY[entityName].prototype.entityNamePlural

      firstDestinationEntityName = availableDestinationEntities[0]
      restOfDestinationEntityNames = availableDestinationEntities[1..]

      baseID = (new Date()).getTime()
      noAdditionalLinks = restOfDestinationEntityNames.length == 0


      if needsToBeDisabled

        glados.Utils.fillContentForElement $linkToAllContainer,
          too_many_items: true
          first_entity: firstDestinationEntityName
          rest_of_entities: ($.extend(n, {too_many_items: true}) for n in restOfDestinationEntityNames)
          generated_id_base: baseID
          no_additional_links: noAdditionalLinks

        $links = $linkToAllContainer.find('.BCK-LinkToOtherEntities')

        qtipText = switch
          when isStreaming then \
          "Please wait until the download is complete"
          when tooManyItems then \
          "Please select or filter less than #{glados.Settings.VIEW_SELECTION_THRESHOLDS.Heatmap[1]} " +
          "items to activate this link."

        $links.qtip
          content:
            text: qtipText
          style:
            classes:'qtip-light'
          position:
            my: 'top middle'
            at: 'bottom middle'

      else

        glados.Utils.fillContentForElement $linkToAllContainer,
          first_entity: firstDestinationEntityName
          rest_of_entities: restOfDestinationEntityNames
          generated_id_base: baseID
          no_additional_links: noAdditionalLinks

        $links = $linkToAllContainer.find('.BCK-LinkToOtherEntities')
        $links.click $.proxy(@handleLinkToOtherEntitiesClick, @)

      unless noAdditionalLinks
        $additionalLinksOpener = $linkToAllContainer.find('.BCK-open-more-links')
        $additionalLinksOpener.click $.proxy(@toggleAdditionalLinks, @)

    toggleAdditionalLinks: ->

      $selectionMenuContainer = $(@el).find('.BCK-selection-menu-container')
      $linkToAllContainer = $selectionMenuContainer.find('.BCK-LinkToOtherEntitiesContainer')
      $additionalLinksContainer = $linkToAllContainer.find(".BCK-additional-links-container")

      if $additionalLinksContainer.attr('data-is-open') == 'yes'
        $additionalLinksContainer.hide()
        $additionalLinksContainer.attr('data-is-open', 'no')
      else
        $additionalLinksContainer.show()
        $additionalLinksContainer.attr('data-is-open', 'yes')

        closeAdditionalLinks = (event) ->

          isOutside = not $linkToAllContainer.is(event.target) and \
            $linkToAllContainer.has(event.target).length == 0

          if isOutside
            $additionalLinksContainer.hide()
            $additionalLinksContainer.attr('data-is-open', 'no')
            $(document).off 'mouseup', closeAdditionalLinks

        $(document).mouseup closeAdditionalLinks

    handleLinkToOtherEntitiesClick: (event) ->

      $clickedElem = $(event.currentTarget)
      destinationEntityName = $clickedElem.attr('data-destination-entity')

      $selectionMenuContainer = $(@el).find('.BCK-selection-menu-container')
      $linkToAllContainer = $selectionMenuContainer.find('.BCK-LinkToOtherEntitiesContainer')
      $preloader = $linkToAllContainer.find(".BCK-preloader[data-destination-entity='#{destinationEntityName}']")
      $preloader.show()

      linkToActPromise = @collection.getLinkToRelatedEntitiesPromise(destinationEntityName)

      linkToActPromise.then (linkGot) ->
        glados.Utils.URLS.shortenLinkIfTooLongAndOpen(linkGot)
        $preloader.hide()

    #--------------------------------------------------------------------------------------
    # Download Buttons
    #--------------------------------------------------------------------------------------

    triggerAllItemsDownload: (event) ->
      desiredFormat = $(event.currentTarget).attr('data-format')

      console.log 'going to generate download for: ', desiredFormat

      if not @downloadModel?
        @downloadModel = new glados.models.Downloads.DownloadModel
          collection: @collection

      if not @downloadView?
        $downloadMessagesElem = $(@el).find('.BCK-download-messages-container')
        @downloadView = new glados.views.Downloads.ServerSideDownloadView
          model: @downloadModel
          el: $downloadMessagesElem

      @downloadModel.startServerSideDownload()

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

      viewElementID = @viewContainerID + '-' + viewType

      # Does the view exist already?
      if !@allViewsPerType[viewType]?
        # No, it does not exist

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