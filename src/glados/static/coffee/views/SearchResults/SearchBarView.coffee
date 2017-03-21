glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the search bar and advanced search components
  SearchBarView: Backbone.View.extend

    # ------------------------------------------------------------------------------------------------------------------
    # Initialization and navigation
    # ------------------------------------------------------------------------------------------------------------------

    el: $('#BCK-SRB-wrapper')
    initialize: () ->
      @atResultsPage = URLProcessor.isAtSearchResultsPage()
      @searchModel = SearchModel.getInstance()
      @es_path = null
      @selected_es_entity = null
      @showAdvanced = false
      @expandable_search_bar = null # Assigned after render
      @small_bar_id = 'BCK-SRB-small'
      @med_andup_bar_id = 'BCK-SRB-med-and-up'
      # re-renders on widnow resize
      @last_screen_type_rendered = null

      # Render variables
      @resultsListsViewsRendered = false
      @$searchResultsListsContainersDict = null
      @searchResultsMenusViewsDict = null
      @searchFacetsViews = null
      @container = null
      @lists_container = null

      # Rendering and resize events
      @render()
      $(window).resize(@render.bind(@))
      @searchModel.bind('change queryString', @updateSearchBarFromModel.bind(@))

      if @atResultsPage
        # Handles the popstate event to reload a search
        @last_location_url = window.location.href
        window.onpopstate = @popStateHandler.bind(@)
        @searchFromURL()

    popStateHandler: ()->
      @atResultsPage = URLProcessor.isAtSearchResultsPage()
      if window.location.href != @last_location_url
        @last_location_url = window.location.href
        if @atResultsPage
          @searchFromURL()
        else
          $(window).scrollTop(0)
          window.location.reload()

    parseURLData: () ->
      @showAdvanced = URLProcessor.isAtAdvancedSearchResultsPage()
      @es_path = URLProcessor.getSpecificSearchResultsPage()
      @selected_es_entity = if _.has(glados.Settings.SEARCH_PATH_2_ES_KEY,@es_path) then \
        glados.Settings.SEARCH_PATH_2_ES_KEY[@es_path] else null

    searchFromURL: ()->
      @parseURLData()
      @showSelectedResourceOnly()
      urlQueryString = decodeURI(URLProcessor.getSearchQueryString())
      if urlQueryString != @lastURLQuery
        @expandable_search_bar.val(urlQueryString)
        @searchModel.search(urlQueryString, null)
        @lastURLQuery = urlQueryString
      @updateChips()
      @updateFacets()

    navigateTo: (nav_url)->
      if URLProcessor.isAtSearchResultsPage(nav_url)
        window.history.pushState({}, 'ChEMBL: '+@expandable_search_bar.val(), nav_url)
        @searchFromURL()
      else
        # Navigates to the specified URL
        window.location.href = nav_url

    # ------------------------------------------------------------------------------------------------------------------
    # Views
    # ------------------------------------------------------------------------------------------------------------------

    updateFacets:()->
      if @searchFacetsViews
        for res_name, facets_wiew of @searchFacetsViews
          facets_wiew.render()

    sortResultsListsViews: ()->
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
        srl_dict = @searchModel.getResultsListsDict()
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

        if @lists_container
          for score_i in sorted_scores
            for resource_name in resources_names_by_score[score_i]
              idToMove =  @getBCKBaseID(resource_name) + '-container'
              $div_key_i = $('#' + idToMove)
              @lists_container.append($div_key_i)

    updateChips: ()->
      # Always generate chips for the results summary
      chipStruct = []
      # Includes an All Results chip to go back to the general results
      chipStruct.push({
        prepend_br: false
        total_records: 0
        label: 'All Results'
        url_path: @getSearchURLFor(null, @expandable_search_bar.val())
        selected: if @selected_es_entity then false else true
      })

      srl_dict = @searchModel.getResultsListsDict()

      for key_i, val_i of glados.models.paginatedCollections.Settings.ES_INDEXES

        totalRecords = srl_dict[key_i].getMeta("total_records")
        if not totalRecords
          totalRecords = 0
        resourceLabel = glados.models.paginatedCollections.Settings.ES_INDEXES[key_i].LABEL
        chipStruct[0].total_records += totalRecords
        chipStruct.push({
          prepend_br: true
          total_records: totalRecords
          label:resourceLabel
          url_path: @getSearchURLFor(key_i, @expandable_search_bar.val())
          selected: @selected_es_entity == key_i
        })

      $('.summary-chips-container').html Handlebars.compile($('#Handlebars-ESResults-Chips').html())
        chips: chipStruct

      glados.Utils.overrideHrefNavigationUnlessTargetBlank(
        $('.summary-chips-container').find('a'), @navigateTo.bind(@)
      )

    showSelectedResourceOnly: ()->
      for resourceName, resultsListSettings of glados.models.paginatedCollections.Settings.ES_INDEXES
        # if there is a selection and this container is not selected it gets hidden if else it shows all resources
        if @selected_es_entity and @selected_es_entity != resourceName
          @$searchResultsListsContainersDict[resourceName].hide()
        else
          @$searchResultsListsContainersDict[resourceName].hide()
          @$searchResultsListsContainersDict[resourceName].show(300)
          if @selected_es_entity == resourceName
            $('#'+@getBCKBaseID(resourceName)+'-filter-link').hide()
            $('#'+@getBCKBaseID(resourceName)+'-all-link').show()
          else
            $('#'+@getBCKBaseID(resourceName)+'-filter-link').show()
            $('#'+@getBCKBaseID(resourceName)+'-all-link').hide()


    renderResultsListsViews: () ->
      # Don't instantiate the ResultsLists if it is not necessary
      if @atResultsPage and not @resultsListsViewsRendered
        @container = $('#BCK-ESResults')
        @lists_container = $('#BCK-ESResults-lists')
        listTitleAndMenuTemplate = Handlebars.compile($("#Handlebars-ESResultsListTitleAndMenu").html())
        listViewTemplate = Handlebars.compile($("#Handlebars-ESResultsListViewContainer").html())

        @searchResultsMenusViewsDict = {}
        @$searchResultsListsContainersDict = {}
        @searchFacetsViews = {}
        # @searchModel.getResultsListsDict() and glados.models.paginatedCollections.Settings.ES_INDEXES
        # Share the same keys to access different objects
        resultsListsDict = @searchModel.getResultsListsDict()
        # Clears the container before redrawing
        @lists_container.html('')
        for resourceName, resultsListSettings of glados.models.paginatedCollections.Settings.ES_INDEXES

          if _.has(resultsListsDict, resourceName)
            resultsListViewID = @getBCKBaseID(resourceName)
            es_results_list_title = resultsListSettings.LABEL
            es_results_url_path = @getSearchURLFor(resourceName, @expandable_search_bar.val())
            es_all_results_url_path = @getSearchURLFor(null, @expandable_search_bar.val())
            $container = $('<div id="' + resultsListViewID + '-container">')

            listTitleContent = listTitleAndMenuTemplate
              es_results_list_id: resultsListViewID
              es_results_list_title: es_results_list_title
              es_results_url_path: es_results_url_path
              es_all_results_url_path: es_all_results_url_path

            listViewContent = listViewTemplate
              es_results_list_id: resultsListViewID
              es_results_url_path: es_results_url_path

            $container.append(listTitleContent)
            $container.append(listViewContent)
            @lists_container.append($container)
            # Link events for links
            glados.Utils.overrideHrefNavigationUnlessTargetBlank(
              $('#'+resultsListViewID+'-filter-link'), @navigateTo.bind(@)
            )
            glados.Utils.overrideHrefNavigationUnlessTargetBlank(
              $('#'+resultsListViewID+'-all-link'), @navigateTo.bind(@)
            )

            # Initialises a Menu view which will be in charge of handling the menu bar,
            # Remember that this is the one that creates, shows and hides the Results lists views! (Matrix, Table, Graph, etc)
            resultsMenuViewI = new glados.views.SearchResults.ResultsSectionMenuView
              collection: resultsListsDict[resourceName]
              el: '#' + resultsListViewID + '-menu'

            resultsMenuViewI.render()

            @searchResultsMenusViewsDict[resourceName] = resultsMenuViewI
            @$searchResultsListsContainersDict[resourceName] = $('#'+resultsListViewID + '-container')

            # event register for score update and update chips
            resultsListsDict[resourceName].on('score_and_records_update',@sortResultsListsViews.bind(@))
            resultsListsDict[resourceName].on('score_and_records_update',@updateChips.bind(@))

            res_facet_view = new glados.views.SearchResults.SearchFacetView
              collection: resultsListsDict[resourceName]
              search_bar_view: @
              collection_container: @$searchResultsListsContainersDict[resourceName]

            @searchFacetsViews[resourceName] = res_facet_view

        @container.show()
        @updateChips()
        @showSelectedResourceOnly()
        @resultsListsViewsRendered = true

    # ------------------------------------------------------------------------------------------------------------------
    # Events Handling
    # ------------------------------------------------------------------------------------------------------------------

    events:
      'click .example_link' : 'searchExampleLink'
      'click #submit_search' : 'search'
      'click #search-opts' : 'searchAdvanced'

    updateSearchBarFromModel: (e) ->
      if @expandable_search_bar
        @expandable_search_bar.val(@searchModel.get('queryString'))

    searchExampleLink: (e) ->
      exampleString = $(e.currentTarget).html()
      @expandable_search_bar.val(exampleString)
      @search()

    # ------------------------------------------------------------------------------------------------------------------
    # Additional Functionalities
    # ------------------------------------------------------------------------------------------------------------------

    getBCKBaseID: (resourceName)->
      return 'BCK-'+glados.models.paginatedCollections.Settings.ES_INDEXES[resourceName].ID_NAME

    getSearchURLFor: (es_settings_key, search_str)->
      selected_es_entity_path = if es_settings_key then \
                                '/'+glados.Settings.ES_KEY_2_SEARCH_PATH[es_settings_key] else ''
      search_url_for_query = glados.Settings.SEARCH_RESULTS_PAGE+\
                              selected_es_entity_path+\
                              '/'+encodeURI(search_str)
      return search_url_for_query

    getCurrentSearchURL: ()->
      return @getSearchURLFor(@selected_es_entity, @expandable_search_bar.val())

    search: () ->
      # Updates the navigation URL
      search_url_for_query = @getCurrentSearchURL()
      window.history.pushState({}, 'ChEMBL: '+@expandable_search_bar.val(), search_url_for_query)
      console.log("SEARCHING FOR:"+@expandable_search_bar.val())
      if @atResultsPage
        @searchModel.search(@expandable_search_bar.val(), null)
      else
        # Navigates to the specified URL
        window.location.href = search_url_for_query

    searchAdvanced: () ->
      searchBarQueryString = @expandable_search_bar.val()
      if @atResultsPage
        @switchShowAdvanced()
      else
        window.location.href = glados.Settings.SEARCH_RESULTS_PAGE+"/"+glados.Settings.SEARCH_RESULTS_PAGE_ADVANCED_PATH+
                "/"+encodeURI(searchBarQueryString)

    switchShowAdvanced: ->
      @showAdvanced = not @showAdvanced
      console.log(@showAdvanced)

    # ------------------------------------------------------------------------------------------------------------------
    # Component rendering
    # ------------------------------------------------------------------------------------------------------------------

    render: () ->
      if @last_screen_type_rendered != GlobalVariables.CURRENT_SCREEN_TYPE
        # on re-render cleans the drawn bar
        $(@el).find('#'+@small_bar_id+',#'+@med_andup_bar_id).html('')
        if GlobalVariables.CURRENT_SCREEN_TYPE == glados.Settings.SMALL_SCREEN
          @fillTemplate(@small_bar_id)
          $(@el).find('#search-bar-small').pushpin
            top : 106
        else
          @fillTemplate(@med_andup_bar_id)
        # Rendders the results lists and the chips
        @renderResultsListsViews()
        @last_screen_type_rendered = GlobalVariables.CURRENT_SCREEN_TYPE

    fillTemplate: (div_id) ->
      div = $(@el).find('#' + div_id)
      template = $('#' + div.attr('data-hb-template'))
      if div and template
        div.html Handlebars.compile(template.html())
          searchBarQueryStr: @searchModel.get('queryString')
          showAdvanced: @showAdvanced
        # Shows the central div of the page after the search bar loads
        if not @atResultsPage
          $('#MainPageCentralDiv').show()

        # expandable search bar
        @expandable_search_bar = ButtonsHelper.createExpandableInput($(@el).find('#search_bar'))
        @expandable_search_bar.onEnter(@search.bind(@))
      else
        console.log("Error trying to render the SearchBarView because the div or the template could not be found")

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

glados.views.SearchResults.SearchBarView.getInstance = () ->
  if not glados.views.SearchResults.SearchBarView.__view_instance
    glados.views.SearchResults.SearchBarView.__view_instance = new glados.views.SearchResults.SearchBarView
  return glados.views.SearchResults.SearchBarView.__view_instance