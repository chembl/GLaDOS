BrowseTargetMainView = Backbone.View.extend

  events:
   'click [type="checkbox"]': 'openAll'

  initialize: ->

    @listView = TargetBrowserApp.initBrowserAsList(@model, $('#BCK-TargetBrowserAsList'))
    @circlesView = TargetBrowserApp.initBrowserAsCircles(@model, $('#BCK-TargetBrowserAsCircles'))

  openAll: ->
    console.log('open all')



