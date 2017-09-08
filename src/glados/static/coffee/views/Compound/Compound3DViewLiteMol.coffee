Compound3DViewLiteMol = Backbone.View.extend

  initialize: ->
    @model.on 'change:current3DData', @render, @

  render: ()->
    current3DData = @model.get('current3DData')
    if current3DData? and $(@el).find('.visualisation-container').is(":visible")
      sdf3DDataURL = 'data:chemical/x-mdl-sdfile;base64,' + btoa(current3DData)
      $(@el).find('.visualisation-container')\
          .html Handlebars.compile($('#Handlebars-LiteMol-Visualisation').html())
            sdf_url: sdf3DDataURL
      angular.bootstrap($(@el).find('pdb-lite-mol')[0], ['pdb.component.library'])

