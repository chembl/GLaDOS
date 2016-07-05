# View that takes care of handling the options in the
# download wizard.
BrowseTargetAsListView = Backbone.View.extend

  initialize: ->
    @render()

  render: ->
    $(@el).find('.tree').treegrid()
    console.log('render!')