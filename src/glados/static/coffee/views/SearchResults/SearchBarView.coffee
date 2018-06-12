glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the search bar and advanced search components
  SearchBarView: Backbone.View.extend

    # ------------------------------------------------------------------------------------------------------------------
    # Initialization and navigation
    # ------------------------------------------------------------------------------------------------------------------

    initialize: () ->
      @searchModel = SearchModel.getInstance()
      @showAdvanced = false

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
      $openEditorBtn = $(@el).find('.draw-structure.hide-on-small-only')
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

    # ------------------------------------------------------------------------------------------------------------------
    # Additional Functionalities
    # ------------------------------------------------------------------------------------------------------------------

    search: () ->
      searchString = @expandable_search_bar.val()
      if GlobalVariables.atSearchResultsPage
        glados.routers.MainGladosRouter.updateSearchURL @selected_es_entity, searchString
        @searchModel.search searchString, null
      else
        # Navigates to the specified URL
        glados.routers.MainGladosRouter.triggerSearchURL @selected_es_entity, searchString,

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
  if $('#chembl-header-search-bar-container').length == 1
    glados.views.SearchResults.SearchBarView.HeaderInstance = new glados.views.SearchResults.SearchBarView
      el: $('#chembl-header-search-bar-container')