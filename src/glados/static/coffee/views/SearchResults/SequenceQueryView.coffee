glados.useNameSpace 'glados.views.SearchResults',
  SequenceQueryView: glados.views.SearchResults.SSQueryView.extend

    initialize: ->

      console.log 'init sequence query view: ', @el
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

      return "https://www.ebi.ac.uk/Tools/services/web/toolresult.ebi?jobId=#{@model.get('search_id')}"


    showEditModal: ->

      glados.helpers.SequenceSearchHelper.showSequenceSearchModal()