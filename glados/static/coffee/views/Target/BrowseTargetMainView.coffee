BrowseTargetMainView = Backbone.View.extend

  events:
   'click .open-all': 'openAll'
   'click .collapse-all': 'collapseAll'
   'click .select-all': 'selectAll'
   'click .clear-selections': 'clearSelections'

  initialize: ->

    @listView = TargetBrowserApp.initBrowserAsList(@model, $('#BCK-TargetBrowserAsList'))
    @circlesView = TargetBrowserApp.initBrowserAsCircles(@model, $('#BCK-TargetBrowserAsCircles'))

  openAll: ->
    @listView.expandAll()

  collapseAll: ->
    @listView.collapseAll()

  selectAll: ->

    for node in @model.get('all_nodes').models
      node.set('selected', true)
      node.set('incomplete', false)

  clearSelections: ->
    for node in @model.get('all_nodes').models
      node.set('selected', false)
      node.set('incomplete', false)








