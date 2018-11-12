glados.useNameSpace 'glados.views.SearchResults',
  SearchResultsView: Backbone.View.extend(glados.views.SearchResults.URLFunctions).extend

    events:
      'click .BCK-select-results-entity': 'openTab'

    initialize: ->

      @browsersDict = {}
      @$searchResultsListsContainersDict = {}
      @selectedESEntity = @attributes?.selectedESEntity || null

      @$listsContainer = $(@el).find('.BCK-ESResults-lists')
      @model.on SearchModel.EVENTS.SEARCH_TERM_HAS_CHANGED, @showPreloader, @
      # @model.getResultsListsDict() and glados.models.paginatedCollections.Settings.ES_INDEXES
      # Share the same keys to access different objects
      @model.resetSearchResultsListsDict()
      resultsListsDict = @model.getResultsListsDict()

      @showPreloader()

      @$listsContainer.empty()
      for resourceName, resultsListSettings of glados.models.paginatedCollections.Settings.ES_INDEXES

        if resultsListsDict[resourceName]?
          resultsListViewID = @getBCKListContainerBaseID(resourceName)
          $container = $('<div id="' + resultsListViewID + '-container">')
          glados.Utils.fillContentForElement($container, {
              entity_name: glados.models.paginatedCollections.Settings.ES_INDEXES[resourceName].LABEL
            },
            'Handlebars-ESResultsList'
          )
          @$listsContainer.append($container)

          # Initialises a Menu view which will be in charge of handling the menu bar,
          # Remember that this is the one that creates, shows and hides the Results lists views! (Matrix, Table, Graph, etc)
          resultsBrowserI = new glados.views.Browsers.BrowserMenuView
            collection: resultsListsDict[resourceName]
            el: $container.find('.BCK-BrowserContainer')
            attributes:
              include_search_results_highlight: true

          resultsBrowserI.render()
          @browsersDict[resourceName] = resultsBrowserI
          @$searchResultsListsContainersDict[resourceName] = $('#' + resultsListViewID + '-container')

      @hideAllResources()
      @model.off('updated_search_and_scores')
      @model.on('updated_search_and_scores', @onUpdatedSearchAndScores, @)

    # ------------------------------------------------------------------------------------------------------------------
    # Preloader
    # ------------------------------------------------------------------------------------------------------------------

    showPreloader: ->
      $tabsContainer = $(@el).find('.BCK-summary-tabs-container')
      glados.Utils.fillContentForElement $tabsContainer, {}, customTemplate=undefined, fillWithPreloader=true
      @hideAllResources()

    # ------------------------------------------------------------------------------------------------------------------
    # Search Model Callback
    # ------------------------------------------------------------------------------------------------------------------

    onUpdatedSearchAndScores: ->
      @selectedESEntity = @model.get('selectedESEntity')
      @sortResultsListsViews()
      @renderTabs()

    # ------------------------------------------------------------------------------------------------------------------
    # sort Elements
    # ------------------------------------------------------------------------------------------------------------------

    sortResultsListsViews: ->
      # If an entity is selected the ordering is skipped
      if not @selectedESEntity
        sortedResourceNamesByScore = @model.get('sortedResourceNamesByScore')
        for resource_name in sortedResourceNamesByScore
          idToMove =  @getBCKListContainerBaseID(resource_name) + '-container'
          $div_key_i = @$listsContainer.find("##{idToMove}")
          @$listsContainer.append($div_key_i)

      @showSelectedResourceOnly()

    # ------------------------------------------------------------------------------------------------------------------
    # Tabs Handling
    # ------------------------------------------------------------------------------------------------------------------
    destroyAllTooltips: -> glados.Utils.Tooltips.destroyAllTooltips($(@el))

    renderTabs: ->
      @destroyAllTooltips()
      # Always generate chips for the results summary
      chipStruct = []
      # Includes an All Results chip to go back to the general results
      chipStruct.push({
        prepend_br: false
        total_records: 0
        label: 'All Results'
        url_path: SearchModel.getInstance().getSearchURL(null, @model.get('queryString'), null)
        selected: if @selectedESEntity then false else true
      })

      resultsListDict = @model.getResultsListsDict()

      for key_i, val_i of glados.models.paginatedCollections.Settings.ES_INDEXES

        totalRecords = resultsListDict[key_i].getMeta("total_records")
        if not totalRecords
          totalRecords = 0
        resourceLabel = glados.models.paginatedCollections.Settings.ES_INDEXES[key_i].LABEL
        chipStruct[0].total_records += totalRecords
        chipStruct.push({
          prepend_br: true
          total_records: totalRecords
          label:resourceLabel
          key: key_i
          url_path: SearchModel.getInstance().getSearchURL(key_i, @model.get('queryString'), null)
          selected: @selectedESEntity == key_i
        })

      $tabsContainer = $(@el).find('.BCK-summary-tabs-container')
      glados.Utils.fillContentForElement $tabsContainer,
        chips: chipStruct

    openTab: (event) ->

      $clickedElem = $(event.currentTarget)
      @selectedESEntity = $clickedElem.attr('data-resource-key')
      $(@el).find('.BCK-select-results-entity').removeClass('selected')
      $clickedElem.addClass('selected')
      SearchModel.getInstance().trigger SearchModel.EVENTS.SEARCH_PARAMS_HAVE_CHANGED, esEntityKey=@selectedESEntity,
        searchTerm=glados.helpers.URLHelper.VALUE_UNCHANGED, currentState=glados.helpers.URLHelper.VALUE_UNCHANGED
      @showSelectedResourceOnly()

    showSelectedResourceOnly: ->

      # if you want to see all, only wake up the first one by default.
      if not @selectedESEntity? or @selectedESEntity == ''
        @showAllTabs()
      else
        @showSelectedTabOnly()

    showAllTabs: ->

      sortedResources = @model.get('sortedResourceNamesByScore')
      firstResourceKey = sortedResources[0]

      for currentKey, resultsListSettings of glados.models.paginatedCollections.Settings.ES_INDEXES
        # if there is a selection and this container is not selected it gets hidden if else it shows all resources
        if currentKey == firstResourceKey
          @browsersDict[currentKey].wakeUp()
        else
          @setUpWakingUpWaypoint(currentKey)
        @$searchResultsListsContainersDict[currentKey].show()

    showSelectedTabOnly: ->

      for currentKey, resultsListSettings of glados.models.paginatedCollections.Settings.ES_INDEXES
        # if there is a selection and this container is not selected it gets hidden if else it shows all resources
        if @selectedESEntity != currentKey
          @$searchResultsListsContainersDict[currentKey].hide()
          @browsersDict[currentKey].sleep()
        else
          @$searchResultsListsContainersDict[currentKey].show()
          @browsersDict[currentKey].wakeUp()

    hideAllResources: ->

      for currentKey, resultsListSettings of glados.models.paginatedCollections.Settings.ES_INDEXES

        $listContainer = @$searchResultsListsContainersDict[currentKey]
        $listContainer.hide() unless not $listContainer? #this can be called at a moment when the containers
        # have not been created
        browserView = @browsersDict[currentKey]
        browserView.sleep() unless not browserView?
    # ------------------------------------------------------------------------------------------------------------------
    # Waking up on scroll
    # ------------------------------------------------------------------------------------------------------------------
    setUpWakingUpWaypoint: (resourceKey)->

      @browsersDict[resourceKey].setUpWakingUpWaypoint()

    # ------------------------------------------------------------------------------------------------------------------
    # Helper functions
    # ------------------------------------------------------------------------------------------------------------------
    getBCKListContainerBaseID: (resourceName) ->
      return 'BCK-'+glados.models.paginatedCollections.Settings.ES_INDEXES[resourceName].ID_NAME
