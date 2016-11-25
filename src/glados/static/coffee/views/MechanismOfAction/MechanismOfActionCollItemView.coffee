# This view renders a collection item
# from the information on the mechanism of action.
MechanismOfActionCollItemView = Backbone.View.extend

  tagName: 'li'
  className: 'collection-item'

  initialize: ->
    @model.on 'change', @.render, @

  render: ->

    rendered = Handlebars.compile($('#Handlebars-Compound-MechanismOfAction-collectionItem').html())
      mechanism_of_action: @model.get('mechanism_of_action')
      target_chembl_id: @model.get('target_chembl_id')

    $(this.el).html(rendered);
    return @