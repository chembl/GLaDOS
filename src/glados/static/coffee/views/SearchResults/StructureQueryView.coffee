glados.useNameSpace 'glados.views.SearchResults',
  StructureQueryView: Backbone.View.extend

    initialize: ->
      @queryParams = arguments[0].query_params
      @render()

    render: ->

      glados.Utils.fillContentForElement $(@el),
        search_term: @queryParams.search_term
        similarity: @queryParams.similarity_percentage
