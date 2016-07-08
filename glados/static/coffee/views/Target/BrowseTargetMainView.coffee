BrowseTargetMainView = Backbone.View.extend

  initialize: ->

    @listView = TargetBrowserApp.initBrowserAsList(@model, $('#BCK-TargetBrowserAsList'))
    @circlesView = TargetBrowserApp.initBrowserAsCircles(@model, $('#BCK-TargetBrowserAsCircles'))

