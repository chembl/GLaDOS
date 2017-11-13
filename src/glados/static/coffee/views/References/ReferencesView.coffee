glados.useNameSpace 'glados.views.References',
  ReferencesView: Backbone.View.extend
    initialize: ->
      @model.on 'change', @render, @

    render: ->

      referencesContainer = $(@el)
      glados.Utils.fillContentForElement referencesContainer
      $(@el).find('.collapsible').collapsible();