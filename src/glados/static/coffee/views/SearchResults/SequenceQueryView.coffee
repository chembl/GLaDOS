glados.useNameSpace 'glados.views.SearchResults',
  SequenceQueryView: glados.views.SearchResults.SSQueryView.extend

    initialize: ->

      @queryParams = @model.get('query_params')
      @model.on 'change:state', @render, @
      @render()


    render: ->

      glados.Utils.fillContentForElement $(@el),
        ebi_job_link: @getEBIJobLink()
        sequence: @queryParams.sequence
        status_text: @getStatusText()
        status_link: @getStatusLink()


    getEBIJobLink: ->

      currentStatus = @model.getState()
      if currentStatus == glados.models.Search.StructureSearchModel.STATES.INITIAL_STATE
        return undefined

      parsedStatusDescription = @model.get('status_description')
      if not parsedStatusDescription?
        return undefined

      ebiJobID = parsedStatusDescription.ebi_job_id
      if not ebiJobID?
        return undefined

      return "https://www.ebi.ac.uk/Tools/services/web/toolresult.ebi?jobId=#{ebiJobID}"


    showEditModal: ->

      glados.helpers.SequenceSearchHelper.showSequenceSearchModal(@queryParams)