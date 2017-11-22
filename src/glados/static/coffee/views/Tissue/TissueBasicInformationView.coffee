TissueBasicInformationView = CardView.extend

  initialize: ->
    CardView.prototype.initialize.call(@, arguments)
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Tissue'
    @showSection()

  render: ->

    @fillTemplate('BCK-TBI-large')
    @fillTemplate('BCK-TBI-small')

    @showCardContent()
    @initEmbedModal('basic_information', @model.get('tissue_chembl_id'))
    @activateModals()

  fillTemplate: (div_id) ->

    div = $(@el).find('#' + div_id)
    template = $('#' + div.attr('data-hb-template'))

    div.html Handlebars.compile(template.html())
      chembl_id: @model.get('tissue_chembl_id')
      name: @model.get('pref_name')
      uberon_id: @model.get('uberon_id')
      efo_id: @model.get('uberon_id')