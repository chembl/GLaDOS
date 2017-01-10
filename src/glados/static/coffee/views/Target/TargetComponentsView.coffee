# View that renders the Target Components section
# from the target report card
# load CardView first!
# also make sure the html can access the handlebars templates!
TargetComponentsView = CardView.extend(PaginatedViewExt).extend(DownloadViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @
    @resource_type = 'Target'

  events: ->
    # aahhh!!! >(
    return _.extend {}, PaginatedViewExt.events, DownloadViewExt.events

  render: ->

    if @collection.size() == 0 and !@collection.getMeta('force_show')
      $('#ApprovedDrugsAndClinicalCandidates').hide()
      return

    @clearContentContainer()

    @fillTemplates()
    @fillPaginators()

    @showCardContent()
    @showPaginatedViewContent()
    @initEmbedModal('components')
    @activateModals()

    @fillPageSelectors()
    @activateSelectors()


  # -----------------------------------------------------------------
  # ---- Downloads
  # -----------------------------------------------------------------
  downloadParserFunction: (attributes) ->

    return attributes.target_components

  getFilename: (format) ->

    if format == 'csv'
      return 'TargetComponents.csv'
    else if format == 'json'
      return 'TargetComponents.json'
    else if format == 'xlsx'
      return 'TargetComponents.xlsx'
    else
      return 'file.txt'