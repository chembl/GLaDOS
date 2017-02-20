Compound3DViewLiteMol = Backbone.View.extend

  initialize: ->

    console.log 'Initialise!!'
    sdfURL = glados.Settings.WS_BASE_URL + 'molecule/' + @model.get('molecule_chembl_id') + '.sdf'
    $(@el).find('.visualisation-container').html Handlebars.compile($('#Handlebars-LieMol-Visualisation').html())
        sdf_url: sdfURL

    angular.bootstrap(document, ['pdb.component.library'])