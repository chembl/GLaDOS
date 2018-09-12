glados.useNameSpace 'glados.views.Browsers',
  QueryEditorView: Backbone.View.extend

    initialize: ->

      console.log 'INIT QueryEditorView: ', $(@el)