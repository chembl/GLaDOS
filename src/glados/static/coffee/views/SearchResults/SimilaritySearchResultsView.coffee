# this is a generic view that is able to show a paginated list from
# web services as an infinite browser
SimilaritySearchResultsView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'do-repaint sync', @.render, @
    @collection.on 'error', @handleError, @
    @isInfinite = true

  render: ->

    $(@el).find('.similar-compounds-title').html Handlebars.compile( $('#Handlebars-SimmilarCompoundsResults-Title').html() )
      similarity: GlobalVariables.SIMILARITY_PERCENTAGE

    if @collection.getMeta('current_page') == 1

      # always clear the infinite container when receiving the first page, to avoid
      # showing results from previous delayed requests.
      @clearContentContainer()

    @showControls()
    @activateSelectors()
    @fillTemplates()
    @fillNumResults()
    @setUpLoadingWaypoint()
    @showPaginatedViewContent()
    @hidePreloaderIfNoNextItems()