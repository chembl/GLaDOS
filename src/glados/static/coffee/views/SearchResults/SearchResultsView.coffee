glados.useNameSpace 'glados.views.SearchResults',
  SearchResultsView: Backbone.View.extend(glados.views.SearchResults.URLFunctions).extend

    events:
      'click .BCK-select-results-entity': 'openTab'

    initialize: ->

      @browsersDict = {}
      @$searchResultsListsContainersDict = {}
      @selected_es_entity = @attributes?.selected_es_entity || null

      @$listsContainer = $(@el).find('.BCK-ESResults-lists')
      # @model.getResultsListsDict() and glados.models.paginatedCollections.Settings.ES_INDEXES
      # Share the same keys to access different objects
      @model.resetSearchResultsListsDict()
      resultsListsDict = @model.getResultsListsDict()

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
      @model.on('updated_search_and_scores', @sortResultsListsViews, @)
      @model.on('updated_search_and_scores', @renderTabs, @)

    # ------------------------------------------------------------------------------------------------------------------
    # sort Elements
    # ------------------------------------------------------------------------------------------------------------------
    sortResultsListsViews: ->

      # If an entity is selected the ordering is skipped
      if not @selected_es_entity
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
        url_path: glados.routers.MainGladosRouter.getSearchURL(null, @model.get('queryString'), null)
        selected: if @selected_es_entity then false else true
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
          url_path: glados.routers.MainGladosRouter.getSearchURL(key_i, @model.get('queryString'), null)
          selected: @selected_es_entity == key_i
        })

      $tabsContainer = $(@el).find('.BCK-summary-tabs-container')
      glados.Utils.fillContentForElement $tabsContainer,
        chips: chipStruct

    openTab: (event) ->

      $clickedElem = $(event.currentTarget)
      @selected_es_entity = $clickedElem.attr('data-resource-key')
      $(@el).find('.BCK-select-results-entity').removeClass('selected')
      $clickedElem.addClass('selected')
      glados.routers.MainGladosRouter.updateSearchURL @selected_es_entity, @model.get('queryString')
      @showSelectedResourceOnly()

    showSelectedResourceOnly: ->

      for currentKey, resultsListSettings of glados.models.paginatedCollections.Settings.ES_INDEXES
        # if there is a selection and this container is not selected it gets hidden if else it shows all resources
        if @selected_es_entity? and @selected_es_entity!= '' and @selected_es_entity != currentKey
          @$searchResultsListsContainersDict[currentKey].hide()
          @browsersDict[currentKey].sleep()
        else
          @$searchResultsListsContainersDict[currentKey].show()
          @browsersDict[currentKey].wakeUp()

    hideAllResources: ->

      for currentKey, resultsListSettings of glados.models.paginatedCollections.Settings.ES_INDEXES

        @$searchResultsListsContainersDict[currentKey].hide()
        @browsersDict[currentKey].sleep()
    # ------------------------------------------------------------------------------------------------------------------
    # Helper functions
    # ------------------------------------------------------------------------------------------------------------------
    getBCKListContainerBaseID: (resourceName) ->
      return 'BCK-'+glados.models.paginatedCollections.Settings.ES_INDEXES[resourceName].ID_NAME
