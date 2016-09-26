# View that renders the Target Components section
# from the target report card
# load CardView first!
# also make sure the html can access the handlebars templates!
TargetComponentsView = CardView.extend(DownloadViewExt).extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Target'

  render: ->

    if @model.get('target_components').length == 0
      $('#TargetComponents').hide()
      $('#TargetComponents').next().hide()
      $(@el).hide()
      return

    @fillTemplates('BCK-Components-large')
    @fillTemplates('BCK-Components-small')

    # until here, all the visible content has been rendered.
    @showVisibleContent()
    @initEmbedModal('components')
    @activateModals()

  fill_template: (div_id) ->

    div = $(@el).find('#' + div_id)
    template = $('#' + div.attr('data-hb-template'))

    div.html Handlebars.compile(template.html())
      component_description: @model.get('component_description')
      relationship: @model.get('relationship')
      components: @model.get('target_components')

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