Compound3DViewLiteMol = Backbone.View.extend

  initialize: ->
    @model.on 'change:current3DData', @render, @

  render: ()->
    current3DData = @model.get('current3DData')
    if current3DData?
      sdf3DDataURL = 'data:chemical/x-mdl-sdfile;base64,' + btoa(current3DData)
      if $(@el).find('pdb-lite-mol').length == 0
        $(@el).find('.visualisation-container')\
            .html Handlebars.compile($('#Handlebars-LiteMol-Visualisation').html())
              sdf_url: sdf3DDataURL
        angular.bootstrap(document, ['pdb.component.library'])
      else
        $(@el).find('pdb-lite-mol').attr('source-url', sdf3DDataURL)

