glados.useNameSpace 'glados.helpers',
  URLHelper: class URLHelper

    @EVENTS:
      SEARCH_PARAMS_UPDATED: ''
    @VALUE_UNCHANGED: '__VALUE_UNCHANGED__'
    @MODES:
      SEARCH_RESULTS: 'SEARCH_RESULTS'
      BROWSE_ENTITY: 'BROWSE_ENTITY'

    constructor: (@mode, @testMode=false) ->

      searchModel = SearchModel.getInstance()
      if @mode == URLHelper.MODES.SEARCH_RESULTS
        searchModel.on SearchModel.EVENTS.SEARCH_PARAMS_HAVE_CHANGED, @triggerUpdateSearchURL, @

    triggerUpdateSearchURL: (esEntityKey, searchTerm, currentState) ->

      @updateSearchURL(esEntityKey, searchTerm, currentState)

    updateSearchURL: (esEntityKey, searchTerm, currentState) ->

      @esEntityKey = esEntityKey
      @searchTerm = searchTerm
      @currentState = currentState

      tabLabelPrefix = ''
      if glados.models.paginatedCollections.Settings.ES_INDEXES[esEntityKey]?
        tabLabelPrefix = glados.models.paginatedCollections.Settings.ES_INDEXES[esEntityKey].LABEL
      breadcrumbLinks = [
        {
          label: (tabLabelPrefix+' Search Results').trim()
          link: SearchModel.getInstance().getSearchURL(@esEntityKey, null, null)
          truncate: true
        }
      ]
      if searchTerm?
        breadcrumbLinks.push(
          {
            label: searchTerm
            link: SearchModel.getInstance().getSearchURL(@esEntityKey, @searchTerm, null)
            truncate: true
          }
        )

      newSearchURL = SearchModel.getInstance().getSearchURL(@esEntityKey, @searchTerm, @currentState, true)

      if @testMode
        return [breadcrumbLinks, newSearchURL]

      window.history.pushState({}, 'Search Results', newSearchURL)
      glados.apps.BreadcrumbApp.setBreadCrumb(breadcrumbLinks, longFilter=undefined,
          hideShareButton=false,longFilterURL=undefined, askBeforeShortening=true)




# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------
glados.helpers.URLHelper.initInstance = (mode, testMode) ->

  if not mode?
    throw "You must specify a mode!"

  if not (mode in _.keys(@MODES))
    throw "Mode '#{mode}' is not valid"

  glados.helpers.URLHelper.__model_instance = new glados.helpers.URLHelper(mode, testMode)

glados.helpers.URLHelper.getInstance = -> glados.helpers.URLHelper.__model_instance
