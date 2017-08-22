# this view is in charge of handling the menu bar that appears on top of the results
glados.useNameSpace 'glados.views.Browsers',
  BrowserMenuView: Backbone.View.extend

    DEFAULT_RESULTS_VIEWS_BY_TYPE:
      'Matrix': glados.views.SearchResults.ESResultsCompoundMatrixView
      'Graph': glados.views.SearchResults.ESResultsGraphView
      'Table': glados.views.PaginatedViews.PaginatedView.getTableConstructor()
      'Cards': glados.views.PaginatedViews.PaginatedView.getCardsConstructor()
      'Infinite': glados.views.PaginatedViews.PaginatedView.getInfiniteConstructor()
      'Bioactivity': glados.views.SearchResults.ESResultsBioactivitySummaryView

    events:
      'click .BCK-download-btn-for-format': 'triggerAllItemsDownload'
      'click .BCK-btn-switch-view': 'switchResultsView'
      'click .BCK-toggle-clear-selections': 'toggleClearSelections'

    initialize: ->

      @collection.on 'reset do-repaint sort', @render, @
      @collection.on glados.Events.Collections.SELECTION_UPDATED, @handleSelection, @

      @currentViewType = @collection.getMeta('default_view')

      # This handles all the views this menu view handles, there is one view per view type, for example
      # {'Table': <instance of table view>}
      @allViewsPerType = {}
      @viewContainerID = @collection.getMeta('id_name')
      @$viewContainer = $(@el).find('.BCK-Items-Container').attr('id', @viewContainerID)

      console.log 'INITIAL VIEW: ', @currentViewType
      @showOrCreateView @currentViewType

      new glados.views.Browsers.BrowserFacetView
        collection: @collection
        el: $(@el).find('.BCK-Facets-Container')

    render: ->

      if not $(@el).is(":visible")
        return

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
            is_disabled: @checkIfViewMustBeDisabled(viewLabel)
          } for viewLabel in @collection.getMeta('available_views'))

        @selectButton @currentViewType

      @addRemoveQtipToButtons()

    #--------------------------------------------------------------------------------------
    # Selections
    #--------------------------------------------------------------------------------------
    checkIfViewMustBeDisabled: (viewLabel) ->

      if glados.Settings.VIEW_SELECTION_THRESHOLDS[viewLabel]?
        numSelectedItems = @collection.getNumberOfSelectedItems()
        threshold = glados.Settings.VIEW_SELECTION_THRESHOLDS[viewLabel]
        if threshold[0] <= numSelectedItems <= threshold[1]
          return false
        else
          return true

      return false

    handleSelection: ->

      $selectionMenuContainer = $(@el).find('.BCK-selection-menu-container')
      numSelectedItems = @collection.getNumberOfSelectedItems()
      glados.Utils.fillContentForElement $selectionMenuContainer,
        num_selected: numSelectedItems
        hide_num_selected: numSelectedItems == 0
        total_items: @collection.getMeta('total_records')
        entity_label: @collection.getMeta('label')
        none_is_selected: not @collection.getMeta('all_items_selected') and not @collection.thereAreExceptions()

      for viewLabel in @collection.getMeta('available_views')
        if @checkIfViewMustBeDisabled(viewLabel)
          @disableButton(viewLabel)
        else
          @enableButton(viewLabel)

    toggleClearSelections: -> @collection.toggleClearSelections()

    #--------------------------------------------------------------------------------------
    # Download Buttons
    #--------------------------------------------------------------------------------------

    triggerAllItemsDownload: (event) ->
      desiredFormat = $(event.currentTarget).attr('data-format')
      $progressMessages = $(@el).find('.download-messages-container')
      @collection.downloadAllItems(desiredFormat, @getCurrentViewInstance().getVisibleColumns(), $progressMessages)

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
        threshold = 'some'
        if glados.Settings.VIEW_SELECTION_THRESHOLDS[viewLabel]?
          thresholdNum = glados.Settings.VIEW_SELECTION_THRESHOLDS[viewLabel]
          threshold = 'from ' + thresholdNum[0] + ' to ' + thresholdNum[1]

        $currentElem.qtip
          content:
            text: 'Select ' + threshold + ' items to activate this view.'
          style:
            classes:'qtip-light'
          position:
            my: 'top right'
            at: 'bottom middle'

    unSelectAllButtons: ->
      $(@el).find('.BCK-btn-switch-view').removeClass('selected')

    selectButton: (type) ->
      $(@el).find('[data-view=' + type + ']').addClass('selected')

    disableButton: (type) ->
      console.log 'DISABLING BUTTON!', type
      $buttonToDisable = $(@el).find('[data-view=' + type + ']')
      console.log '$buttonToDisable: ', $buttonToDisable
      $buttonToDisable.addClass('disabled')
      @addRemoveQtipToButtons()

    enableButton: (type) ->
      console.log 'ENABLING BUTTON!', type
      $buttonToEnable = $(@el).find('[data-view=' + type + ']')
      $buttonToEnable.removeClass('disabled')
      @addRemoveQtipToButtons()

    switchResultsView: (event) ->
      $clickedElem = $(event.currentTarget)

      if $clickedElem.hasClass('disabled')
        return

      desiredViewType = $clickedElem.attr('data-view')
      console.log 'SWITCH TO VIEW: ', desiredViewType

      @unSelectAllButtons()
      @selectButton desiredViewType

      @hideView @currentViewType
      @showOrCreateView desiredViewType
      @currentViewType = desiredViewType

    # if the view already exists, shows it, otherwise it creates it.
    showOrCreateView: (viewType) ->

      viewElementID = @viewContainerID + '-' + viewType

      if !@allViewsPerType[viewType]?

        console.log 'view ', viewType, ' did not exist'
        $viewContainer = $('#' + @viewContainerID)
        $viewElement = $('<div>').attr('id', viewElementID)
        templateName = 'Handlebars-Common-ESResultsList' + viewType + 'View'
        console.log 'TEMPLATE NAME: ', templateName
        $viewElement.html Handlebars.compile($('#' + templateName).html())()
        $viewContainer.append($viewElement)
        console.log '$viewElement: ', $viewElement

        # Instantiates the results list view for each ES entity and links them with the html component
        newView = new @DEFAULT_RESULTS_VIEWS_BY_TYPE[viewType]
          collection: @collection
          el: $viewElement
          custom_render_evts: undefined
          render_at_init: true

        @allViewsPerType[viewType] = newView

      else

        console.log 'view ', viewType, ' exists already! just need to wake it up'
        $('#' + viewElementID).show()
        # wake up the view if necessary
        if @allViewsPerType[viewType].wakeUpView?
          @allViewsPerType[viewType].wakeUpView()

    hideView: (viewType) ->

      if @allViewsPerType[viewType].sleepView?
          @allViewsPerType[viewType].sleepView()

      viewElementID = @viewContainerID + '-' + viewType
      console.log 'hiding view:', viewElementID
      $('#' + viewElementID).hide()

    getCurrentViewInstance: -> @allViewsPerType[@currentViewType]



