# View that renders a list of resulting documents as paginated cards.
DocumentsFromTermsView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'do-repaint', @.render, @
    @isInfinite = true

  render: ->

    $desc = $(@el).find('.list-description')
    $template = $('#' + $desc.attr('data-hb-template'))
    $desc.html Handlebars.compile( $template.html() )
      term: GlobalVariables.SEARCH_TERM_DECODED

    console.log 'num items in collection: ', @collection.models.length
    console.log 'items: ', _.map(@collection.models, (item) -> item.get('document_chembl_id'))


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

    console.log 'num cards: ', $(@el).find('.BCK-items-container').children().length