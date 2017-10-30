TargetAssociatedAssaysView = CardView.extend

  initialize: ->

    @model.on 'change', @render, @
    @resource_type = 'Target'

    config =
      x_axis_prop_name: 'types'
      title: gettext('glados_target__associated_assays_pie_title_base') + @model.get('target_chembl_id')
    @paginatedView = new PieView
      model: @model
      el: @el
      config: config

    @initEmbedModal('associated_assays')
    @activateModals()

  render: -> @showCardContent()