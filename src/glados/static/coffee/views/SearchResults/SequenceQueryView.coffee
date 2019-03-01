glados.useNameSpace 'glados.views.SearchResults',
  SequenceQueryView: glados.views.SearchResults.SSQueryView.extend


    initialize: ->

      @queryParams = @model.get('query_params')
      @model.on 'change:state', @render, @
      @render()


    render: ->

      console.log 'render: ', @getStatusText()
      console.log 'state: ', @model.get('state')
      glados.Utils.fillContentForElement $(@el),
        sequence: @queryParams.sequence
        status_text: @getStatusText()
        status_link: @getStatusLink()


    showEditModal: ->

      glados.helpers.SequenceSearchHelper.showSequenceSearchModal()