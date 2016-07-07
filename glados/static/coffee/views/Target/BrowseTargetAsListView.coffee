BrowseTargetAsListView = Backbone.View.extend

  initialize: ->
    @render()

  render: ->
    tree = $(@el).find('.tree')
    tree.treegrid()
    tree.treegrid('collapseAll')
    console.log('render as list!')