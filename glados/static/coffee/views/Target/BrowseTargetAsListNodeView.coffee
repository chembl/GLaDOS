BrowseTargetAsListNodeView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @changed, @

  events:
   'click [type="checkbox"]': 'clickInput'


  clickInput: ->
   @model.set('name', 'osin!!')

   console.log(@model)
   console.log('input clicked!')
   @model.trigger('change')

  changed: ->
    console.log('changed!')
