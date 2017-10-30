TargetAssociatedBioactivitiesView = CardView.extend

  initialize: ->

    @target_chembl_id = arguments[0].target_chembl_id
    @model.on 'change', @render, @
    @resource_type = 'Target'

    config =
      x_axis_prop_name: 'types'

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
