# This view renders materialize column with a card that contains the a compound
# in the molecule forms section.
CompoundMoleculeFormView = Backbone.View.extend

  tagName: 'div'
  className: 'col s6 m4 l3'

  initialize: ->
    @model.on 'change', @.render, @

  render: ->

    colour = if @model.get('molecule_chembl_id') == CHEMBL_ID then 'teal lighten-5' else ''

    $(this.el).html Handlebars.compile($('#Handlebars-Compound-AlternateFormCard').html())
      molecule_chembl_id: @model.get('molecule_chembl_id')
      colour: colour

    return @