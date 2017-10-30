glados.useNameSpace 'glados.views.ReportCards',
  PieInCardView: CardView.extend

    initialize: ->

      @model.on 'change', @render, @
      @resource_type = 'Target'

      config =
        x_axis_prop_name: 'types'
        title: gettext('glados_target__associated_activities_pie_title_base') + @model.get('target_chembl_id')

      @paginatedView = new PieView
        model: @model
        el: $(@el).find('.BCK-Main-Pie-container')
        config: config

      @initEmbedModal('bioactivities')
      @activateModals()

  render: ->

    @showCardContent()

    if @model.get('state') != glados.models.Aggregations.Aggregation.States.INITIAL_STATE or \
    @model.get('state') == glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE
      return

    $linkToActivities = $(@el).find('.BCK-bioactivities-link')
    glados.Utils.fillContentForElement $linkToActivities,
      target_chembl_id: @model.get('target_chembl_id')
      url: Activity.getActivitiesListURL('target_chembl_id:' + @model.get('target_chembl_id'))


