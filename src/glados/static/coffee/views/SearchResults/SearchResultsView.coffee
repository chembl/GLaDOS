glados.useNameSpace 'glados.views.SearchResults',
  SearchResultsView: Backbone.View.extend
    initialize: ->

      @searchResultsMenusViewsDict = {}
      @$searchResultsListsContainersDict = {}

      $listsContainer = $(@el).find('.BCK-ESResults-lists')
      console.log '$listsContainer: ', $listsContainer
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
        url_path: @getSearchURLFor(null, @model.get('query_string'))
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
          url_path: @getSearchURLFor(key_i, @model.get('query_string'))
          selected: @selected_es_entity == key_i
        })

      $tabsContainer = $(@el).find('.BCK-summary-tabs-container')
      glados.Utils.fillContentForElement $tabsContainer,
        chips: chipStruct

      glados.Utils.overrideHrefNavigationUnlessTargetBlank(
        $('.BCK-summary-tabs-container').find('a'), @navigateTo.bind(@)
      )


    navigateTo: ->
      console.log 'NAVIGATION!'

    getBCKListContainerBaseID: (resourceName) ->
      return 'BCK-'+glados.models.paginatedCollections.Settings.ES_INDEXES[resourceName].ID_NAME

    getEntityName: (resourceName) -> resourceName.replace(/_/g, ' ').toLowerCase() + 's'

    getSearchURLFor: (es_settings_key, search_str)->
      selected_es_entity_path = if es_settings_key then \
                                '/'+glados.Settings.ES_KEY_2_SEARCH_PATH[es_settings_key] else ''
      search_url_for_query = glados.Settings.SEARCH_RESULTS_PAGE+\
                              selected_es_entity_path+\
                              '/'+encodeURI(search_str)
      return search_url_for_query

    getCurrentSearchURL: ()->
      return @getSearchURLFor(@selected_es_entity, @expandable_search_bar.val())
