# this view is in charge of handling the menu bar that appears on top of the results
glados.useNameSpace 'glados.views.SearchResults',
  ResultsSectionMenuView: Backbone.View.extend

    DEFAULT_RESULTS_VIEWS_BY_TYPE:
      'Matrix': glados.views.SearchResults.ESResultsCompoundMatrixView
      'Graph': glados.views.SearchResults.ESResultsListView
      'Table': glados.views.SearchResults.ESResultsListView
      'Cards': glados.views.SearchResults.ESResultsListView
      'Infinite': glados.views.SearchResults.ESResultsListView


    events:
      'click .BCK-download-btn-for-format': 'triggerAllItemsDownload'
      'click .BCK-btn-switch-view': 'switchResultsView'

    initialize: ->
      @collection.on 'reset do-repaint sort', @render, @
      @currentViewType = @collection.getMeta('default_view')

      # This handles all the views this menu view handles, there is one view per view type, for example
      # {'Table': <instance of table view>}
      @allViewsPerType = {}
      @viewContainerID = $(@el).attr('id').replace('-menu', '')

      @showOrCreateView @currentViewType

    render: ->
      if @collection.getMeta('total_records') != 0

        $downloadBtnsContainer = $(@el).find('.BCK-download-btns-container')
        $downloadBtnsContainer.html Handlebars.compile($('#' + $downloadBtnsContainer.attr('data-hb-template')).html())
          formats: @collection.getMeta('download_formats')

        $changeViewBtnsContainer = $(@el).find('.BCK-changeView-btns-container')
        $changeViewBtnsContainer.html Handlebars.compile($('#' + $changeViewBtnsContainer.attr('data-hb-template')).html())
          options: ( {
            label: viewLabel,
            icon_class: glados.Settings.DEFAULT_RESULTS_VIEWS_ICONS[viewLabel]
          } for viewLabel in @collection.getMeta('available_views'))

        @selectButton @currentViewType

    #--------------------------------------------------------------------------------------
    # Download Buttons
    #--------------------------------------------------------------------------------------

    triggerAllItemsDownload: (event) ->
      desiredFormat = $(event.currentTarget).attr('data-format')
      $progressMessages = $(@el).find('.download-messages-container')
      @collection.downloadAllItems(desiredFormat, $progressMessages)

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
        resultsListView = new @DEFAULT_RESULTS_VIEWS_BY_TYPE[viewType]
          collection: @collection
          el: $viewElement

        @allViewsPerType[viewType] = resultsListView

      else

        console.log 'view ', viewType, ' exist already!'
        $('#' + viewElementID).show()

    hideView: (viewType) ->

      viewElementID = @viewContainerID + '-' + viewType
      console.log 'hiding view:', viewElementID
      $('#' + viewElementID).hide()




