CompoundMetabolismFSView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @.render, @

    @metView = new glados.views.Compound.MetabolismView
      model: @model
      el: $(@el).find('#BCK-metabolism-visualisation-container')

  render: ->

    $(@el).find('.visualisation-title').html Handlebars.compile( $('#Handlebars-MetabolismVisualisationFS-Title').html() )
      chembl_id: GlobalVariables.CHEMBL_ID

    glados.apps.Main.MainGladosApp.hideMainSplashScreen()

