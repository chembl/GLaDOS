# View that renders a list of resulting documents as paginated cards.
DocumentsFromTermsView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @

  render: ->

    $desc = $(@el).find('.list-description')
    $template = $('#' + $desc.attr('data-hb-template'))

    $desc.html Handlebars.compile( $template.html() )
      term: GlobalVariables.SEARCH_TERM_DECODED

    @clearContentContainer()
    @fillTemplates()
    @fillPaginators()
    @fillPageSelectors()
    @renderSortingSelector()
    @activateSelectors()
    @showPaginatedViewContent()