glados.useNameSpace 'glados.views.base',
  TrackView:

    initTracking: (viewName, viewType, entityName) ->
      console.debug "init registration binding for view #{viewName} of type #{viewType}. Entity Name: #{entityName}"
      $(@el).click @generateClickTracker(viewName, viewType, entityName)

    generateClickTracker: (viewName, viewType, entityName) ->

      return ->

        paramsDict =
          view_name: viewName
          view_type: viewType
          entity_name: entityName

        registerUsage = glados.doCSRFPost(glados.Settings.REGISTER_USAGE_ENDPOINT, paramsDict)
        registerUsage.then (data) -> console.debug "usage for #{viewName} registered"
        registerUsage.fail (data) -> console.debug "usage registration for #{viewName} failed!"

    registerSearchUsage: (searchType) ->

      paramsDict =
        search_type: searchType

      registerSearch = glados.doCSRFPost(glados.Settings.REGISTER_SEARCH_ENDPOINT, paramsDict)
      registerSearch.then (data) -> console.debug "#{searchType} search registered"
      registerSearch.fail (data) -> console.debug "#{searchType} search failed!"

glados.views.base.TrackView.viewTypes =
  CARD: 'CARD'
  VISUALISATION: 'VISUALISATION'

glados.views.base.TrackView.searchTypes =
  FREE_TEXT: 'FREE_TEXT'
  SUBSTRUCTURE: 'SUBSTRUCTURE'
  SIMILARITY: 'SIMILARITY'
  CONNECTIVITY: 'CONNECTIVITY'
  BLAST: 'BLAST'
  OTHER: 'OTHER'