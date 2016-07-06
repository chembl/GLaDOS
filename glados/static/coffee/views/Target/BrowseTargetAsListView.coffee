# View that takes care of handling the options in the
# download wizard.
BrowseTargetAsListView = Backbone.View.extend

  initialize: ->
    @render()

  render: ->
    tree = $(@el).find('.tree')
    tree.treegrid()
    tree.treegrid('collapseAll')
    console.log('render!')