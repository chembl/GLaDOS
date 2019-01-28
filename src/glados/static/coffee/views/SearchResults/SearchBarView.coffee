glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the search bar and advanced search components
  SearchBarView: Backbone.View.extend

    # ------------------------------------------------------------------------------------------------------------------
    # Initialization and navigation
    # ------------------------------------------------------------------------------------------------------------------

    initialize: () ->
      @searchModel = SearchModel.getInstance()
      @showAdvanced = false

      @selectedESEntity = null
      @expandable_search_bar = ButtonsHelper.createExpandableInput($(@el).find('.chembl-search-bar'))
      @expandable_search_bar.onEnter(@search.bind(@))
      # Rendering and resize events
      @searchModel.on('change:queryString', @updateSearchBarFromModel.bind(@))
      autocompleteElemFind = $(@el).find('.autocomplete-hb')
      autocompleteElem = $(autocompleteElemFind[0])
      @autocompleteView = new glados.views.SearchResults.SearchBarAutocompleteView
        el: autocompleteElem
      @autocompleteView.attachSearchBar(@)
      @initializeSketcherButton()

    initializeSketcherButton: ()->
      $openEditorBtn = $(@el).find('.BCK-Draw-Structure')
      $openEditorBtn.click glados.helpers.ChemicalEditorHelper.showChemicalEditorModal


    # ------------------------------------------------------------------------------------------------------------------
    # Events Handling
    # ------------------------------------------------------------------------------------------------------------------

    events:
      'click .search-button' : 'search'
      'click .search-opts' : 'searchAdvanced'

    updateSearchBarFromModel: (e) ->
      if @expandable_search_bar
        @expandable_search_bar.val(@searchModel.get('queryString'))
        @selectedESEntity = @searchModel.get('selectedESEntity')

    # ------------------------------------------------------------------------------------------------------------------
    # Additional Functionalities
    # ------------------------------------------------------------------------------------------------------------------

    search: (customSearchString=undefined, customSelectedEntity=undefined) ->
      if customSelectedEntity? and _.isString(customSelectedEntity)
        @selectedESEntity = customSelectedEntity
      if not @selectedESEntity in glados.models.paginatedCollections.Settings.ES_INDEXES
        @selectedESEntity = null
      searchString = if customSearchString? and _.isString(customSearchString) then customSearchString else @expandable_search_bar.val()
      if GlobalVariables.atSearchResultsPage
        SearchModel.getInstance().trigger(SearchModel.EVENTS.SEARCH_PARAMS_HAVE_CHANGED, @selectedESEntity,
          searchString)
        @searchModel.search(searchString, @selectedESEntity)
      else
        # Navigates to the specified URL
        glados.routers.MainGladosRouter.triggerSearchURL(@selectedESEntity, searchString)

    searchAdvanced: () ->
      return

    switchShowAdvanced: ->
      @showAdvanced = not @showAdvanced

# ----------------------------------------------------------------------------------------------------------------------
# Instances Initialization
# ----------------------------------------------------------------------------------------------------------------------

glados.views.SearchResults.SearchBarView.createInstances = () ->
  glados.views.SearchResults.SearchBarView.BCKSRBInstance = undefined
  if $('#BCK-SRB-wrapper').length == 1
    glados.views.SearchResults.SearchBarView.BCKSRBInstance = new glados.views.SearchResults.SearchBarView
      el: $('#BCK-SRB-wrapper')
  glados.views.SearchResults.SearchBarView.HeaderInstance = undefined
  if $('#BCK-SearchBarContainer').length == 1
    glados.views.SearchResults.SearchBarView.HeaderInstance = new glados.views.SearchResults.SearchBarView
      el: $('#BCK-SearchBarContainer')