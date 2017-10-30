TargetAssociatedBioactivitiesView = CardView.extend

  initialize: ->

    @model.on 'change', @render, @
    @resource_type = 'Target'

    config =
      x_axis_prop_name: 'types'
      title: gettext('glados_target__associated_assays_pie_title_base') + @model.get('target_chembl_id')

    @paginatedView = new PieView
      model: @model
      el: $(@el).find('.BCK-Main-Pie-container')
      config: config

    @initEmbedModal('bioactivities')
    @activateModals()

  render: ->

    console.log 'target chembl id:', @target_chembl_id
    @showCardContent()
    buckets = @model.get('buckets')

    if buckets?
      if buckets.length > 0
        $linkToActivities = $(@el).find('.BCK-bioactivities-link')
        glados.Utils.fillContentForElement $linkToActivities,
          target_chembl_id: @target_chembl_id
          url: Activity.getActivitiesListURL('target_chembl_id:' + @target_chembl_id)
