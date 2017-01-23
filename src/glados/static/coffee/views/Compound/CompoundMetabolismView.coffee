# View that renders the Compound Metabolism Section
CompoundMetabolismView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Compound'

  render: ->

#    glados.Settings.BASE_COMPOUND_METABOLISM_FS_URL

    $(@el).find('.visualisation-title').html Handlebars.compile( $('#Handlebars-MetabolismVisualisation-Title').html() )
      chembl_id: GlobalVariables.CHEMBL_ID

    $(@el).find('.visualisation-fullscreen-link').html Handlebars.compile( $('#Handlebars-MetabolismVisualisation-FSLink').html() )
      chembl_id: GlobalVariables.CHEMBL_ID


    @showCardContent()
    MetabolismVisualizator._loadFromVariable("metabolism-visualisation-container", @model.get('graph'))

    @initEmbedModal('metabolism')
    @activateModals()

