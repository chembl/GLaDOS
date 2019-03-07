glados.useNameSpace 'glados.views.SearchResults',
  SSQueryView: Backbone.View.extend

    events:
      'click .BCK-Edit-Query': 'showEditModal'

    getStatusText: ->

      currentStatus = @model.getState()
      if currentStatus == glados.models.Search.StructureSearchModel.STATES.INITIAL_STATE
        return 'Submitting'
      else if currentStatus == glados.models.Search.StructureSearchModel.STATES.ERROR_STATE
        return 'There was an error. Please try again later.'
      else if currentStatus == glados.models.Search.StructureSearchModel.STATES.SEARCH_QUEUED
        return 'Submitted'
      else if currentStatus == glados.models.Search.StructureSearchModel.STATES.SEARCHING
        return 'Searching'
      else if currentStatus == glados.models.Search.StructureSearchModel.STATES.LOADING_RESULTS
        return 'Loading Results'
      else if currentStatus == glados.models.Search.StructureSearchModel.STATES.FINISHED
        return 'Results Ready'


    getStatusLink: ->

      currentStatus = @model.getState()
      if currentStatus != glados.models.Search.StructureSearchModel.STATES.INITIAL_STATE
        return @model.getProgressURL()
      else return undefined