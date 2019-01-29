glados.useNameSpace 'glados.views.SearchResults',
  SequenceSearchView: Backbone.View.extend

    initialize: ->

      @render()

    render: ->

      loadPromise = glados.Utils.fillContentForElement($(@el))
      loadPromise.then ->
        console.log 'content loaded'



