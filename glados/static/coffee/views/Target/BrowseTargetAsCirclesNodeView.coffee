BrowseTargetAsCirclesNodeView = Backbone.View.extend

  initialize: ->

     @model.on 'change', @changed, @

  events:
    'click': 'clicked'

  changed: ->

    console.log(@model.get('name') + ' changed')

  clicked: ->
    console.log('clicked ' + @model.get('name'))
