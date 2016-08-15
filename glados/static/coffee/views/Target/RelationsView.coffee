# View that renders the Target relations section
# from the target report card
# load CardView first!
RelationsView = CardView.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @resource_type = 'Target'

  render: ->

    if @collection.size() == 0 and !@collection.getMeta('force_show')
      $('#TargetRelations').hide()
      return

    @clearTable()
    @clearList()

    @fill_template('TRTable-large')
    @fill_template('TR-UL-small')
    @fillPaginator('TR-paginator')

    @showVisibleContent()
    @initEmbedModal('relations')
    @activateModals()

    @activatePageSelector();

  clearTable: ->

    $('#TRTable-large').empty()

  clearList: ->

    $('#TR-UL-small').empty()


