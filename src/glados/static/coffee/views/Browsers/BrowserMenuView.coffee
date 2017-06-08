# this view is in charge of handling the menu bar that appears on top of the results
glados.useNameSpace 'glados.views.Browsers',
  BrowserMenuView: Backbone.View.extend

    DEFAULT_RESULTS_VIEWS_BY_TYPE:
      'Matrix': glados.views.SearchResults.ESResultsCompoundMatrixView
      'Graph': glados.views.SearchResults.ESResultsGraphView
      'Table': glados.views.PaginatedViews.PaginatedView.getTableConstructor()
      'Cards': glados.views.PaginatedViews.PaginatedView.getCardsConstructor()
      'Infinite': glados.views.PaginatedViews.PaginatedView.getCardsConstructor()


    events:
      'click .BCK-download-btn-for-format': 'triggerAllItemsDownload'
      'click .BCK-btn-switch-view': 'switchResultsView'
      'click .BCK-select-all': 'selectAll'
      'click .BCK-unSelect-all': 'unSelectAll'

    initialize: ->
      @collection.on 'reset do-repaint sort', @render, @
      @collection.on glados.Events.Collections.SELECTION_UPDATED, @renderSelectionMenu, @

      @currentViewType = @collection.getMeta('default_view')

      # This handles all the views this menu view handles, there is one view per view type, for example
      # {'Table': <instance of table view>}
      @allViewsPerType = {}
      @viewContainerID = $(@el).attr('id').replace('-menu', '')

      console.log 'view id: ', $(@el).attr('id')
      console.log 'INITIAL VIEW: ', @currentViewType
      @showOrCreateView @currentViewType

    render: ->
      if @collection.getMeta('total_records') != 0

        $downloadBtnsContainer = $(@el).find('.BCK-download-btns-container')
        $downloadBtnsContainer.html Handlebars.compile($('#' + $downloadBtnsContainer.attr('data-hb-template')).html())
          formats: @collection.getMeta('download_formats')

        @renderSelectionMenu()
        $changeViewBtnsContainer = $(@el).find('.BCK-changeView-btns-container')
        $changeViewBtnsContainer.html Handlebars.compile($('#' + $changeViewBtnsContainer.attr('data-hb-template')).html())
          options: ( {
            label: viewLabel,
            icon_class: glados.Settings.DEFAULT_RESULTS_VIEWS_ICONS[viewLabel]
          } for viewLabel in @collection.getMeta('available_views'))

        @selectButton @currentViewType

    #--------------------------------------------------------------------------------------
    # Selections
    #--------------------------------------------------------------------------------------
    renderSelectionMenu: ->

      $selectionMenuContainer = $(@el).find('.BCK-selection-menu-container')
      glados.Utils.fillContentForElement $selectionMenuContainer,
        num_selected: @collection.getNumberOfSelectedItems()
        total_items: @collection.getMeta('total_records')

    selectAll: -> @collection.selectAll()
    unSelectAll: -> @collection.unSelectAll()

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
    unSelectAllButtons: ->

      $(@el).find('.BCK-btn-switch-view').removeClass('accent-4')

    selectButton: (type) ->

      $(@el).find('[data-view=' + type + ']').addClass('accent-4')

    switchResultsView: (event) ->
      desiredViewType = $(event.currentTarget).attr('data-view')
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
        templateName = 'Handlebars-ESResultsList' + viewType + 'View'
        $viewElement.html Handlebars.compile($('#' + templateName).html())()
        $viewContainer.append($viewElement)

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



