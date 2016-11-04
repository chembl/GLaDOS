BrowseTargetAsCirclesNodeView = Backbone.View.extend

  initialize: ->

    @elem_selector = '#'+ $(@el).attr('id')
    @model.on 'change', @changed, @
    @model.on TargetHierarchyNode.NODE_FOCUSED_EVT, @focused, @

  events:
    'click': 'clicked'

  changed: ->

    d3.select(@elem_selector).classed('selected', @model.get('selected') == true)

  clicked: ->

    console.log('clicked ' + @model.get('name'))

  focused: ->

    @parentView.focusTo d3.select(@elem_selector).data()[0]
