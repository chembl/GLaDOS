BrowseTargetAsCirclesNodeView = Backbone.View.extend

  initialize: ->

    @elem_selector = '#'+ $(@el).attr('id')
    @model.on 'change', @changed, @

  events:
    'click': 'clicked'

  changed: ->


    d3.select(@elem_selector).classed('selected', @model.get('selected') == true)


    console.log(@model.get('name') + ' changed')
    console.log($(@el))

  clicked: ->

    console.log('clicked ' + @model.get('name'))
