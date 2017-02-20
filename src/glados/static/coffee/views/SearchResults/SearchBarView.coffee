glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the search bar and advanced search components
  SearchBarView: Backbone.View.extend

    # --------------------------------------------------------------------------------------------------------------------
    # Initialization
    # --------------------------------------------------------------------------------------------------------------------

    el: $('#BCK-SRB-wrapper')
    initialize: () ->
      @showAdvanced = URLProcessor.isAtAdvancedSearchResultsPage()
      @atResultsPage = URLProcessor.isAtSearchResultsPage()
      @searchModel = SearchModel.getInstance()
      @es_path = null
      @selected_es_entity = null

      @expandable_search_bar = null # Assigned after render
      @small_bar_id = 'BCK-SRB-small'
      @med_andup_bar_id = 'BCK-SRB-med-and-up'
      # re-renders on widnow resize
      @last_screen_type_rendered = null
      @render()
      $(window).resize(@render.bind(@))
      @searchModel.bind('change queryString', @updateSearchBarFromModel.bind(@))
      # Handles the popstate event to reload a search
      window.onpopstate = @searchFromURL.bind(@)
      @searchFromURL()

    searchFromURL: ()->
      if @atResultsPage
        @es_path = URLProcessor.getSpecificSearchResultsPage()
        @selected_es_entity = if _.has(glados.Settings.SEARCH_PATH_2_ES_KEY,@es_path) then \
          glados.Settings.SEARCH_PATH_2_ES_KEY[@es_path] else null

        # Don't instantiate the ResultsLists if it is not necessary
        @container = $('#BCK-ESResults')
        @lists_container = $('#BCK-ESResults-lists')
        @renderResultsListsViews()
        urlQueryString = decodeURI(URLProcessor.getSearchQueryString())
        if urlQueryString and urlQueryString != @lastURLQuery
          @expandable_search_bar.val(urlQueryString)
          @searchModel.search(urlQueryString, null)
          @lastURLQuery = urlQueryString

    # --------------------------------------------------------------------------------------------------------------------
    # Views
    # --------------------------------------------------------------------------------------------------------------------

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
        keys_by_score = {}
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

            if not _.has(keys_by_score,score_i)
              keys_by_score[score_i] = []
            keys_by_score[score_i].push(key_i)
            insert_score_in_order(score_i)

        if @lists_container
          for score_i in sorted_scores
            for key_i in keys_by_score[score_i]
              $div_key_i = $('#BCK-'+glados.models.paginatedCollections.Settings.ES_INDEXES[key_i].ID_NAME)
              @lists_container.append($div_key_i)

    updateChips: ()->
      # Always generate chips for the results summary
      chipStruct = []
      # Includes an All Results chip to go back to the general results
      chipStruct.push({
        total_records: 0
        label: 'All Results'
        url_path: @getSearchURLFor(null, @expandable_search_bar.val())
      })

      srl_dict = @searchModel.getResultsListsDict()

      for key_i, val_i of glados.models.paginatedCollections.Settings.ES_INDEXES

        totalRecords = srl_dict[key_i].getMeta("total_records")
        resourceLabel = glados.models.paginatedCollections.Settings.ES_INDEXES[key_i].LABEL
        chipStruct[0].total_records += totalRecords
        chipStruct.push({
          total_records: totalRecords
          label:resourceLabel
          url_path: @getSearchURLFor(key_i, @expandable_search_bar.val())
        })

      $('.summary-chips-container').html Handlebars.compile($('#' + 'Handlebars-ESResults-Chips').html())
        chips: chipStruct


    renderResultsListsViews: () ->
      list_template = Handlebars.compile($("#Handlebars-ESResultsListCards").html())

      @searchResultsViewsDict = {}
      # @searchModel.getResultsListsDict() and glados.models.paginatedCollections.Settings.ES_INDEXES
      # Share the same keys to access different objects
      srl_dict = @searchModel.getResultsListsDict()
      for key_i, val_i of glados.models.paginatedCollections.Settings.ES_INDEXES

        if _.has(srl_dict, key_i)
          es_results_list_id = 'BCK-'+val_i.ID_NAME
          es_results_list_title = val_i.LABEL
          @lists_container.append(
            list_template(
              es_results_list_id: es_results_list_id
              es_results_list_title: es_results_list_title
            )
          )
          # Instantiates the results list view for each ES entity and links them with the html component
          es_rl_view_i = new glados.views.SearchResults.ESResultsListView
            collection: srl_dict[key_i]
            el: '#'+es_results_list_id
          @searchResultsViewsDict[key_i] = es_rl_view_i
          # If there is a selection skips the unselected views
          if @selected_es_entity and @selected_es_entity != key_i
            $('#'+es_results_list_id).hide()
          # event register for score update and update chips
          srl_dict[key_i].on('score_and_records_update',@sortResultsListsViews.bind(@))
          srl_dict[key_i].on('score_and_records_update',@updateChips.bind(@))
      @container.show()

    # --------------------------------------------------------------------------------------------------------------------
    # Events Handling
    # --------------------------------------------------------------------------------------------------------------------

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

    # --------------------------------------------------------------------------------------------------------------------
    # Additional Functionalities
    # --------------------------------------------------------------------------------------------------------------------

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

    # --------------------------------------------------------------------------------------------------------------------
    # Component rendering
    # --------------------------------------------------------------------------------------------------------------------

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