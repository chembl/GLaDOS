glados.useNameSpace 'glados.helpers',
  URLHelper: class URLHelper

    @VALUE_UNCHANGED: '__VALUE_UNCHANGED__'
    @MODES:
      SEARCH_RESULTS: 'SEARCH_RESULTS'
      BROWSE_ENTITY: 'BROWSE_ENTITY'

    constructor: ->

      @testMode = glados.helpers.URLHelper.testMode
      # set a default mode just in case
      @setMode(URLHelper.MODES.SEARCH_RESULTS)

    setMode: (currentMode) ->

      @mode = currentMode
      searchModel = SearchModel.getInstance()
      if @mode == URLHelper.MODES.SEARCH_RESULTS
        searchModel.on SearchModel.EVENTS.SEARCH_PARAMS_HAVE_CHANGED, @triggerUpdateSearchURL, @
      else
        searchModel.off SearchModel.EVENTS.SEARCH_PARAMS_HAVE_CHANGED, @triggerUpdateSearchURL

    triggerUpdateSearchURL: (esEntityKey, searchTerm, currentState) ->

      @updateSearchURL(esEntityKey, searchTerm, currentState)

    updateSearchURL: (esEntityKey, searchTerm, currentState) ->

      if esEntityKey != glados.helpers.URLHelper.VALUE_UNCHANGED
        @esEntityKey = esEntityKey
      if searchTerm != glados.helpers.URLHelper.VALUE_UNCHANGED
        @searchTerm = searchTerm
      if currentState != glados.helpers.URLHelper.VALUE_UNCHANGED
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
glados.helpers.URLHelper.getInstance = ->

  if not glados.helpers.URLHelper.__model_instance?
    glados.helpers.URLHelper.__model_instance = new glados.helpers.URLHelper()
  return glados.helpers.URLHelper.__model_instance
