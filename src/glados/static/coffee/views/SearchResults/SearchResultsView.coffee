glados.useNameSpace 'glados.views.SearchResults',
  SearchResultsView: Backbone.View.extend(glados.views.SearchResults.URLFunctions).extend
    initialize: ->

      @searchResultsMenusViewsDict = {}
      @$searchResultsListsContainersDict = {}
      @selected_es_entity = null
      @es_path = null
      @parseURLData()

      $listsContainer = $(@el).find('.BCK-ESResults-lists')
      # @model.getResultsListsDict() and glados.models.paginatedCollections.Settings.ES_INDEXES
      # Share the same keys to access different objects
      resultsListsDict = @model.getResultsListsDict()

      $listsContainer.empty()
      for resourceName, resultsListSettings of glados.models.paginatedCollections.Settings.ES_INDEXES

        if resultsListsDict[resourceName]?
          resultsListViewID = @getBCKListContainerBaseID(resourceName)
          $container = $('<div id="' + resultsListViewID + '-container">')
          glados.Utils.fillContentForElement($container, {entity_name: @getEntityName(resourceName)},
            'Handlebars-ESResultsList')
          $listsContainer.append($container)

          # Initialises a Menu view which will be in charge of handling the menu bar,
          # Remember that this is the one that creates, shows and hides the Results lists views! (Matrix, Table, Graph, etc)
          resultsMenuViewI = new glados.views.Browsers.BrowserMenuView
            collection: resultsListsDict[resourceName]
            el: $container.find('.BCK-BrowserContainer')

          resultsMenuViewI.render()
          @searchResultsMenusViewsDict[resourceName] = resultsMenuViewI
          @$searchResultsListsContainersDict[resourceName] = $('#'+resultsListViewID + '-container')
          resultsListsDict[resourceName].on('score_and_records_update',@sortResultsListsViews, @)
          resultsListsDict[resourceName].on('score_and_records_update',@renderTabs, @)

      @showSelectedResourceOnly()
      @renderTabs()

    # ------------------------------------------------------------------------------------------------------------------
    # sort Elements
    # ------------------------------------------------------------------------------------------------------------------
    sortResultsListsViews: ->

      # If an entity is selected the ordering is skipped
      if not @selected_es_entity
        sorted_scores = []
        insert_score_in_order = (_score)->
          inserted = false
          for score_i, i in sorted_scores
            if score_i < _score
              sorted_scores.splice(i,0,_score)
              inserted = true
              break
          if not inserted
            sorted_scores.push(_score)
        resources_names_by_score = {}
        srl_dict = @model.getResultsListsDict()
        for key_i, val_i of glados.models.paginatedCollections.Settings.ES_INDEXES
          if _.has(srl_dict, key_i)
            score_i = srl_dict[key_i].getMeta("max_score")
            total_records = srl_dict[key_i].getMeta("total_records")
            if not score_i
              score_i = 0
            if not total_records
              total_records = 0
            # Boost compounds and targets to the top!
            boost = 1
            if val_i.KEY_NAME == glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
              boost = 100
            else if val_i.KEY_NAME == glados.models.paginatedCollections.Settings.ES_INDEXES.TARGET.KEY_NAME
              boost = 50
            score_i *= boost

            if not _.has(resources_names_by_score,score_i)
              resources_names_by_score[score_i] = []
            resources_names_by_score[score_i].push(key_i)
            insert_score_in_order(score_i)

        $listsContainer = $(@el).find('.BCK-ESResults-lists')
        for score_i in sorted_scores
          for resource_name in resources_names_by_score[score_i]
            idToMove =  @getBCKListContainerBaseID(resource_name) + '-container'
            $div_key_i = $('#' + idToMove)
            $listsContainer.append($div_key_i)

    # ------------------------------------------------------------------------------------------------------------------
    # Tabs Handling
    # ------------------------------------------------------------------------------------------------------------------
    renderTabs: ->
      # Always generate chips for the results summary
      chipStruct = []
      # Includes an All Results chip to go back to the general results
      chipStruct.push({
        prepend_br: false
        total_records: 0
        label: 'All Results'
        url_path: @getSearchURLFor(null, @model.get('queryString'))
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
          url_path: @getSearchURLFor(key_i, @model.get('queryString'))
          selected: @selected_es_entity == key_i
        })

      $tabsContainer = $(@el).find('.BCK-summary-tabs-container')
      glados.Utils.fillContentForElement $tabsContainer,
        chips: chipStruct

      glados.Utils.overrideHrefNavigationUnlessTargetBlank(
        $('.BCK-summary-tabs-container').find('a'), @navigateTo.bind(@)
      )

    parseURLData: () ->
      @es_path = URLProcessor.getSpecificSearchResultsPage()
      @selected_es_entity = if _.has(glados.Settings.SEARCH_PATH_2_ES_KEY,@es_path) then \
        glados.Settings.SEARCH_PATH_2_ES_KEY[@es_path] else null

    navigateTo: (navUrl) ->
      window.history.pushState({}, 'ChEMBL: ' + @model.get('queryString'), navUrl)
      @parseURLData()
      @showSelectedResourceOnly()
      @renderTabs()

    showSelectedResourceOnly: ->

      for resourceName, resultsListSettings of glados.models.paginatedCollections.Settings.ES_INDEXES
        # if there is a selection and this container is not selected it gets hidden if else it shows all resources
        if @selected_es_entity and @selected_es_entity != resourceName
          @$searchResultsListsContainersDict[resourceName].hide()
        else
          @$searchResultsListsContainersDict[resourceName].hide()
          @$searchResultsListsContainersDict[resourceName].show()
          if @selected_es_entity == resourceName
            $('#'+@getBCKListContainerBaseID(resourceName)+'-filter-link').hide()
            $('#'+@getBCKListContainerBaseID(resourceName)+'-all-link').show()
          else
            $('#'+@getBCKListContainerBaseID(resourceName)+'-filter-link').show()
            $('#'+@getBCKListContainerBaseID(resourceName)+'-all-link').hide()

    # ------------------------------------------------------------------------------------------------------------------
    # Helper functions
    # ------------------------------------------------------------------------------------------------------------------
    getBCKListContainerBaseID: (resourceName) ->
      return 'BCK-'+glados.models.paginatedCollections.Settings.ES_INDEXES[resourceName].ID_NAME

    getEntityName: (resourceName) -> resourceName.replace(/_/g, ' ').toLowerCase() + 's'
