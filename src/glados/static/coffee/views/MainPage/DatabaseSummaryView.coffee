glados.useNameSpace 'glados.views.MainPage',
  DatabaseSummaryView: Backbone.View.extend

    initialize: ->
      @model.on 'change', @render, @

    render: ->
      console.log 'RENDER DATABASE SUMMARY'
      @showContent()

    showContent: ->
      $(@el).find('.card-preolader-to-hide').hide()
      $(@el).find('.BCK-content').show()


