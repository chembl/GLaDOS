glados.useNameSpace 'glados.views.MainPage',
  AssociatedResourcesView: Backbone.View.extend

    initialize: ->
      console.log 'im the associated resources view !!!!'
      @render()

    render: ->
      console.log 'I will render chembl associated resources :)'


