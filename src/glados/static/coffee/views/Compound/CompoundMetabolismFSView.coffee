CompoundMetabolismFSView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @.render, @

  render: ->

    $(@el).find('.visualisation-title').html Handlebars.compile( $('#Handlebars-MetabolismVisualisationFS-Title').html() )
      chembl_id: GlobalVariables.CHEMBL_ID

    MetabolismVisualizator._loadFromVariable("metabolism-visualisation-container", @model.get('graph'))