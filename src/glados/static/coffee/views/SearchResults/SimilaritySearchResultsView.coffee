# this is a generic view that is able to show a paginated list from
# web services as an infinite browser
SimilaritySearchResultsView = Backbone.View.extend

  initialize: ->
    @collection.on 'sync', @.render, @
    @paginatedView = glados.views.PaginatedViews.PaginatedView.getNewInfinitePaginatedView(@collection, @el)

  render: ->

    glados.Utils.fillContentForElement $(@el).find('.similar-compounds-title'),
      similarity: GlobalVariables.SIMILARITY_PERCENTAGE