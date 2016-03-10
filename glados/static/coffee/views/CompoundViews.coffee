# View that renders the Compound Name and Classification section
# from the compound report card
CompoundNameClassificationView = Backbone.View.extend

  render: ->
    attributes = @model.toJSON()
    @renderTitle()

  renderTitle: ->
    $(@el).find('.Bck-CHEMBL_ID').text(@model.get('molecule_chembl_id'))


