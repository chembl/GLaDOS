glados.useNameSpace 'glados.views.ReportCards',
  MetabolismInCardView: CardView.extend

    initialize: ->
      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @.render, @
      @model.on 'error', @.showCompoundErrorCard, @
      @resource_type = 'Compound'
      @molecule_chembl_id = arguments[0].molecule_chembl_id

      @metView = new glados.views.Compound.MetabolismView
        model: @model
        el: $(@el).find('#BCK-metabolism-visualisation-container')

    render: ->

      @showSection()
      $(@el).find('.visualisation-title').html Handlebars.compile( $('#Handlebars-MetabolismVisualisation-Title').html() )
        chembl_id: @molecule_chembl_id

      $(@el).find('.visualisation-fullscreen-link').html Handlebars.compile( $('#Handlebars-MetabolismVisualisation-FSLink').html() )
        chembl_id: @molecule_chembl_id

      @showCardContent()

      @initEmbedModal('metabolism', @molecule_chembl_id)
      @activateModals()

