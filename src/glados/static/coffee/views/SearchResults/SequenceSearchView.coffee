glados.useNameSpace 'glados.views.SearchResults',
  SequenceSearchView: Backbone.View.extend

    initialize: ->

      loadPromise = glados.Utils.fillContentForElement($(@el))
      loadPromise.then ->
        console.log 'CONTENT LOADED'

    render: ->



