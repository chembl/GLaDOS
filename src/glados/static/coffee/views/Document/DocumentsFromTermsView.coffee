# View that renders a list of resulting documents as paginated cards.
DocumentsFromTermsView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'sync', @.render, @
    @isInfinite = true
    @paginatedView = glados.views.PaginatedViews.PaginatedView.getNewInfinitePaginatedView(@collection, @el, 'do-repaint')

  render: ->

    glados.Utils.fillContentForElement $(@el).find('.list-description'),
      term: GlobalVariables.SEARCH_TERM_DECODED